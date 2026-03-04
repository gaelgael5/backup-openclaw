# Stratégie de Sauvegarde MyCoach - Base de Données & Fichiers

**Date**: 2026-03-02  
**Responsable**: Sysadmin OpenClaw  
**Objectif**: Garantir la disponibilité et l'intégrité des données

---

## 🎯 **OBJECTIFS DE SAUVEGARDE**

### **RTO/RPO Targets**
- **RTO** (Recovery Time Objective) : < 4 heures  
- **RPO** (Recovery Point Objective) : < 15 minutes
- **Disponibilité cible** : 99.9% (8.76h downtime/an)

### **Données Critiques**
1. **Base PostgreSQL** : Profils, performances, paiements
2. **Fichiers utilisateurs** : Avatars, documents de certification  
3. **Configuration** : Docker Compose, variables d'env, Nginx config
4. **Logs applicatifs** : Audit trail, debugging

---

## 🗄️ **ARCHITECTURE DE SAUVEGARDE**

```
[Source Proxmox]
    ↓
[Backup Local] (Snapshots LXC)
    ↓ 
[Backup Remote] (S3/NAS)
    ↓
[Archive Cold Storage] (Glacier/Tape)

Timeline:
- Temps réel : PostgreSQL WAL
- 15min : Snapshots LXC  
- 4h : Dump PostgreSQL
- Daily : Archive complète
- Weekly : Cold storage
```

---

## 📊 **MATRICE DES DONNÉES**

| Type de donnée | Criticité | Fréquence | Rétention | Méthode |
|----------------|-----------|-----------|-----------|---------|
| PostgreSQL DB | 🔴 Critique | 15min | 90 jours | pg_dump + WAL |
| Fichiers users | 🟠 Important | 4h | 30 jours | rsync + compression |
| Config Docker | 🟡 Modéré | Daily | 30 jours | Git + tar.gz |
| Logs applicatifs | 🟢 Faible | Daily | 7 jours | logrotate + compress |
| Snapshots LXC | 🔴 Critique | 6h | 7 jours | Proxmox built-in |

---

## 🔄 **STRATÉGIE POSTGRESQL**

### **Base de Données : Approche 3-2-1**
- **3** copies : Original + 2 backups
- **2** supports différents : Local + Remote  
- **1** backup offsite : Cloud storage

### **Configuration PostgreSQL**
```sql
-- postgresql.conf
wal_level = replica
archive_mode = on
archive_command = 'cp %p /backup/wal/%f'
max_wal_senders = 3
wal_keep_segments = 32
checkpoint_timeout = 5min
```

### **Scripts de Sauvegarde DB**

#### **Dump complet quotidien**
```bash
#!/bin/bash
# backup-postgres-daily.sh

set -e

DB_NAME="mycoach"
BACKUP_DIR="/opt/mycoach/backups/postgres"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=90

# Créer répertoire s'il n'existe pas
mkdir -p "$BACKUP_DIR"

# Dump avec compression
echo "Starting PostgreSQL backup at $(date)"
docker exec mycoach_postgres pg_dump \
  -U mycoach \
  -h localhost \
  -d "$DB_NAME" \
  --verbose \
  --format=custom \
  --compress=9 \
  > "$BACKUP_DIR/mycoach_${DATE}.dump"

# Vérifier l'intégrité
if pg_restore --list "$BACKUP_DIR/mycoach_${DATE}.dump" > /dev/null; then
  echo "✅ Backup successful: mycoach_${DATE}.dump"
  
  # Nettoyer anciens backups
  find "$BACKUP_DIR" -name "*.dump" -mtime +$RETENTION_DAYS -delete
  
  # Upload vers stockage distant
  aws s3 cp "$BACKUP_DIR/mycoach_${DATE}.dump" \
    s3://mycoach-backups/postgres/ \
    --storage-class STANDARD_IA
else
  echo "❌ Backup verification failed"
  exit 1
fi

echo "Backup completed at $(date)"
```

#### **WAL Archiving continu**
```bash
#!/bin/bash  
# wal-archive.sh

WAL_FILE="$1"
WAL_PATH="$2"
ARCHIVE_DIR="/opt/mycoach/backups/wal"

# Copier WAL localement
cp "$WAL_PATH" "$ARCHIVE_DIR/$WAL_FILE"

# Upload vers S3 (asynchrone)
aws s3 cp "$ARCHIVE_DIR/$WAL_FILE" \
  s3://mycoach-backups/wal/ \
  --storage-class STANDARD &

# Nettoyer anciens WAL (garder 7 jours)
find "$ARCHIVE_DIR" -name "*.wal" -mtime +7 -delete
```

### **Point-in-Time Recovery**
```bash
#!/bin/bash
# restore-postgres-pitr.sh

TARGET_TIME="$1"  # Format: 2026-03-02 14:30:00
BACKUP_DIR="/opt/mycoach/backups"

echo "🔄 Starting Point-in-Time Recovery to $TARGET_TIME"

# Arrêter l'application
docker-compose stop mycoach-api

# Restaurer le dernier backup complet
LATEST_DUMP=$(ls -1t $BACKUP_DIR/postgres/*.dump | head -1)
echo "Restoring from: $LATEST_DUMP"

# Créer nouvelle DB temporaire
docker exec mycoach_postgres createdb -U mycoach mycoach_recovery

# Restaurer dump
docker exec -i mycoach_postgres pg_restore \
  -U mycoach \
  -d mycoach_recovery \
  --verbose \
  < "$LATEST_DUMP"

# Appliquer WAL jusqu'au point de recovery
# (Configuration dans recovery.conf)
echo "restore_command = 'cp $BACKUP_DIR/wal/%f %p'" > recovery.conf
echo "recovery_target_time = '$TARGET_TIME'" >> recovery.conf

echo "✅ Recovery completed"
```

---

## 📁 **SAUVEGARDE FICHIERS UTILISATEURS**

### **Structure des Données**
```
/opt/mycoach/
├── data/
│   ├── uploads/avatars/          # Avatars utilisateurs
│   ├── uploads/certifications/   # Documents coaches
│   └── uploads/temp/            # Fichiers temporaires
├── config/
│   ├── docker-compose.yml
│   ├── .env.*                   # Variables d'environnement  
│   └── nginx/                   # Configuration Nginx
└── backups/
    ├── postgres/               # Dumps DB
    ├── wal/                   # WAL files
    └── files/                 # Archives fichiers
```

### **Script de Sauvegarde Fichiers**
```bash
#!/bin/bash
# backup-files.sh

set -e

SOURCE_DIR="/opt/mycoach/data"
BACKUP_DIR="/opt/mycoach/backups/files"
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="mycoach_files_${DATE}.tar.gz"

echo "Starting file backup at $(date)"

# Créer archive compressée
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" \
  --exclude="*/temp/*" \
  --exclude="*.tmp" \
  -C "$SOURCE_DIR" .

# Vérifier l'intégrité
if tar -tzf "$BACKUP_DIR/$ARCHIVE_NAME" > /dev/null; then
  echo "✅ File backup successful: $ARCHIVE_NAME"
  
  # Upload vers S3
  aws s3 cp "$BACKUP_DIR/$ARCHIVE_NAME" \
    s3://mycoach-backups/files/ \
    --storage-class STANDARD_IA
    
  # Nettoyer localement (garder 7 jours)
  find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete
else
  echo "❌ File backup verification failed"
  exit 1
fi

echo "File backup completed at $(date)"
```

### **Synchronisation en Temps Réel**
```bash
#!/bin/bash
# rsync-continuous.sh

# Sync uploads vers backup secondaire
rsync -avz --delete \
  /opt/mycoach/data/uploads/ \
  /backup/mycoach-secondary/uploads/

# Sync vers NAS (si disponible)
rsync -avz --delete \
  /opt/mycoach/data/uploads/ \
  nas.internal:/volume1/backups/mycoach/uploads/
```

---

## 📦 **SNAPSHOTS PROXMOX**

### **Configuration LXC Snapshots**
```bash
#!/bin/bash  
# lxc-snapshot.sh

CTID="102"  # Container MyCoach
SNAPSHOT_NAME="backup-$(date +%Y%m%d-%H%M)"
RETENTION_SNAPSHOTS=7

echo "Creating LXC snapshot: $SNAPSHOT_NAME"

# Créer snapshot
pct snapshot "$CTID" "$SNAPSHOT_NAME" \
  --description "Automated backup $(date)"

# Nettoyer anciens snapshots
pct listsnapshot "$CTID" | tail -n +2 | sort -k2 | head -n -$RETENTION_SNAPSHOTS | \
while read snap_name snap_date desc; do
  echo "Removing old snapshot: $snap_name"
  pct delsnapshot "$CTID" "$snap_name"
done

echo "✅ Snapshot created: $SNAPSHOT_NAME"
```

### **Cron Job Proxmox**
```cron
# Snapshots toutes les 6h
0 */6 * * * /opt/scripts/lxc-snapshot.sh

# Backup vzdump hebdomadaire
0 2 * * 0 vzdump 102 --storage local-lvm --mode snapshot --compress gzip
```

---

## ☁️ **STOCKAGE DISTANT**

### **Configuration AWS S3**
```bash
# aws configure
AWS_ACCESS_KEY_ID=AKIAI...
AWS_SECRET_ACCESS_KEY=secret...
AWS_DEFAULT_REGION=eu-west-3

# Créer bucket avec lifecycle
aws s3 mb s3://mycoach-backups

# Politique de lifecycle
cat > lifecycle-policy.json << EOF
{
  "Rules": [
    {
      "ID": "PostgreSQLBackups",
      "Status": "Enabled",
      "Filter": {"Prefix": "postgres/"},
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "GLACIER"
        },
        {
          "Days": 90,  
          "StorageClass": "DEEP_ARCHIVE"
        }
      ]
    }
  ]
}
EOF

aws s3api put-bucket-lifecycle-configuration \
  --bucket mycoach-backups \
  --lifecycle-configuration file://lifecycle-policy.json
```

### **Alternative : NAS Local**
```bash
# Configuration NAS Synology/QNAP
# Rsync quotidien vers NAS
#!/bin/bash
# sync-to-nas.sh

NAS_HOST="192.168.10.200"
NAS_USER="backup"
NAS_PATH="/volume1/mycoach-backups"

# Sync backups PostgreSQL
rsync -avz --delete \
  /opt/mycoach/backups/postgres/ \
  $NAS_USER@$NAS_HOST:$NAS_PATH/postgres/

# Sync fichiers utilisateurs  
rsync -avz --delete \
  /opt/mycoach/backups/files/ \
  $NAS_USER@$NAS_HOST:$NAS_PATH/files/
```

---

## 🔄 **PROCÉDURES DE RESTAURATION**

### **Restauration PostgreSQL Complète**
```bash
#!/bin/bash
# restore-postgres.sh

DUMP_FILE="$1"  # chemin vers fichier .dump

if [ -z "$DUMP_FILE" ]; then
  echo "Usage: $0 <dump_file.dump>"
  exit 1
fi

echo "🔄 Starting PostgreSQL restoration"

# Arrêter l'application
docker-compose stop mycoach-api

# Backup DB actuelle (par sécurité)
docker exec mycoach_postgres pg_dump -U mycoach mycoach > current_backup.sql

# Drop/Recreate database
docker exec mycoach_postgres dropdb -U mycoach mycoach
docker exec mycoach_postgres createdb -U mycoach mycoach

# Restaurer
docker exec -i mycoach_postgres pg_restore \
  -U mycoach -d mycoach --verbose < "$DUMP_FILE"

# Redémarrer l'application
docker-compose start mycoach-api

echo "✅ PostgreSQL restoration completed"
```

### **Restauration Fichiers**
```bash
#!/bin/bash
# restore-files.sh

ARCHIVE_FILE="$1"  # chemin vers archive .tar.gz

if [ -z "$ARCHIVE_FILE" ]; then
  echo "Usage: $0 <archive.tar.gz>"
  exit 1
fi

echo "🔄 Starting file restoration"

# Backup actuel
mv /opt/mycoach/data/uploads /opt/mycoach/data/uploads.backup.$(date +%s)

# Créer répertoire
mkdir -p /opt/mycoach/data/uploads

# Extraire archive
tar -xzf "$ARCHIVE_FILE" -C /opt/mycoach/data/uploads/

# Corriger permissions
chown -R www-data:www-data /opt/mycoach/data/uploads
chmod -R 755 /opt/mycoach/data/uploads

echo "✅ File restoration completed"
```

### **Restauration depuis Snapshot LXC**
```bash
#!/bin/bash
# restore-lxc-snapshot.sh

CTID="102"
SNAPSHOT_NAME="$1"

if [ -z "$SNAPSHOT_NAME" ]; then
  echo "Available snapshots:"
  pct listsnapshot $CTID
  exit 1
fi

echo "🔄 Restoring LXC snapshot: $SNAPSHOT_NAME"

# Arrêter container
pct stop $CTID

# Restaurer snapshot
pct rollback $CTID $SNAPSHOT_NAME

# Démarrer container  
pct start $CTID

echo "✅ LXC restoration completed"
```

---

## 📊 **MONITORING & ALERTES**

### **Surveillance des Backups**
```bash
#!/bin/bash
# monitor-backups.sh

BACKUP_DIR="/opt/mycoach/backups"
ALERT_EMAIL="admin@mycoach.com"

check_postgres_backup() {
  LATEST=$(ls -1t $BACKUP_DIR/postgres/*.dump 2>/dev/null | head -1)
  if [ -z "$LATEST" ]; then
    echo "❌ No PostgreSQL backup found"
    return 1
  fi
  
  AGE=$(stat -c %Y "$LATEST")
  NOW=$(date +%s)
  HOURS=$(( (NOW - AGE) / 3600 ))
  
  if [ $HOURS -gt 25 ]; then  # >25h = problème
    echo "❌ PostgreSQL backup too old: ${HOURS}h"
    return 1
  fi
  
  echo "✅ PostgreSQL backup OK: ${HOURS}h old"
  return 0
}

check_file_backup() {
  LATEST=$(ls -1t $BACKUP_DIR/files/*.tar.gz 2>/dev/null | head -1)
  if [ -z "$LATEST" ]; then
    echo "❌ No file backup found"
    return 1
  fi
  
  AGE=$(stat -c %Y "$LATEST")
  NOW=$(date +%s)
  HOURS=$(( (NOW - AGE) / 3600 ))
  
  if [ $HOURS -gt 25 ]; then
    echo "❌ File backup too old: ${HOURS}h"
    return 1
  fi
  
  echo "✅ File backup OK: ${HOURS}h old"
  return 0
}

# Vérifications
ERRORS=""
check_postgres_backup || ERRORS="${ERRORS}PostgreSQL backup issue\n"
check_file_backup || ERRORS="${ERRORS}File backup issue\n"

if [ -n "$ERRORS" ]; then
  echo -e "$ERRORS" | mail -s "MyCoach Backup Alert" "$ALERT_EMAIL"
  exit 1
else
  echo "✅ All backups are healthy"
  exit 0
fi
```

### **Métriques de Sauvegarde**
```bash
# Tailles des backups
du -sh /opt/mycoach/backups/*

# Utilisation S3
aws s3 ls s3://mycoach-backups --recursive --human-readable --summarize

# Logs de backup
tail -f /var/log/mycoach-backup.log
```

---

## 📅 **PLANNING AUTOMATISÉ**

### **Crontab Principal**
```cron
# PostgreSQL dump quotidien
0 2 * * * /opt/scripts/backup-postgres-daily.sh >> /var/log/mycoach-backup.log 2>&1

# Sauvegarde fichiers toutes les 4h  
0 */4 * * * /opt/scripts/backup-files.sh >> /var/log/mycoach-backup.log 2>&1

# Snapshots LXC toutes les 6h
0 */6 * * * /opt/scripts/lxc-snapshot.sh

# Sync vers NAS quotidien
0 3 * * * /opt/scripts/sync-to-nas.sh >> /var/log/mycoach-backup.log 2>&1

# Monitoring des backups  
30 8 * * * /opt/scripts/monitor-backups.sh

# Nettoyage WAL hebdomadaire
0 1 * * 0 find /opt/mycoach/backups/wal -mtime +7 -delete
```

---

## ⚠️ **TESTS & VALIDATION**

### **Test de Restauration Mensuel**
```bash
#!/bin/bash
# test-restore-monthly.sh

echo "🧪 Starting monthly restore test"

# Créer environnement de test
docker-compose -f docker-compose.test.yml up -d

# Tester restauration PostgreSQL
LATEST_DUMP=$(ls -1t /opt/mycoach/backups/postgres/*.dump | head -1)
docker exec test_postgres pg_restore -U mycoach -d test_mycoach < "$LATEST_DUMP"

# Tester restauration fichiers
LATEST_FILES=$(ls -1t /opt/mycoach/backups/files/*.tar.gz | head -1)
tar -xzf "$LATEST_FILES" -C /tmp/test-restore/

# Valider données
USERS_COUNT=$(docker exec test_postgres psql -U mycoach -d test_mycoach -t -c "SELECT COUNT(*) FROM users;")
FILES_COUNT=$(find /tmp/test-restore -type f | wc -l)

echo "Users restored: $USERS_COUNT"
echo "Files restored: $FILES_COUNT"

# Nettoyer
docker-compose -f docker-compose.test.yml down
rm -rf /tmp/test-restore

echo "✅ Monthly restore test completed"
```

### **Validation d'Intégrité**
```bash
#!/bin/bash
# validate-backup-integrity.sh

# Test PostgreSQL dump
for dump in /opt/mycoach/backups/postgres/*.dump; do
  if ! pg_restore --list "$dump" > /dev/null 2>&1; then
    echo "❌ Corrupted dump: $dump"
  fi
done

# Test archives fichiers
for archive in /opt/mycoach/backups/files/*.tar.gz; do
  if ! tar -tzf "$archive" > /dev/null 2>&1; then
    echo "❌ Corrupted archive: $archive"
  fi
done

echo "✅ Backup integrity validation completed"
```

---

## 📋 **CHECKLIST DÉPLOIEMENT**

### **Infrastructure**
- [ ] Espace disque suffisant (>100GB backup)
- [ ] AWS S3 configuré avec lifecycle
- [ ] NAS/stockage secondaire disponible
- [ ] Snapshots LXC activés  
- [ ] Monitoring backup en place

### **PostgreSQL**
- [ ] WAL archiving configuré
- [ ] Compression activée sur dumps
- [ ] Point-in-time recovery testé
- [ ] Permissions utilisateur backup
- [ ] Rotation automatique WAL

### **Fichiers**
- [ ] Rsync vers stockage distant  
- [ ] Archives compressées
- [ ] Exclusion fichiers temporaires
- [ ] Test restauration fichiers
- [ ] Permissions préservées

### **Automatisation**
- [ ] Cron jobs configurés
- [ ] Scripts de backup testés
- [ ] Alertes email fonctionnelles  
- [ ] Logs centralisés
- [ ] Documentation à jour

---

**Next**: Consulter `monitoring-setup.md` pour superviser l'infrastructure et détecter les problèmes en amont.