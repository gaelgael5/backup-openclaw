# MyCoach Infrastructure - Phase 1

Infrastructure complète pour le projet MyCoach avec Docker Compose, CI/CD, monitoring, SSL et backups automatisés.

## 🏗️ Architecture

```
┌─────────────────┬─────────────────┬─────────────────┐
│   Load Balancer │   Application   │   Database      │
│                 │                 │                 │
│  Nginx (SSL)    │  FastAPI        │  PostgreSQL 15  │
│  - Rate Limiting│  - JWT Auth     │  - Optimized    │
│  - Compression  │  - API Docs     │  - Backups      │
│  - Security     │  - Health Check │  - Monitoring   │
└─────────────────┼─────────────────┼─────────────────┤
│                 │   Cache         │   Monitoring    │
│                 │                 │                 │
│                 │  Redis          │  Prometheus     │
│                 │  - Sessions     │  Grafana        │
│                 │  - Cache        │  Loki (Logs)    │
└─────────────────┴─────────────────┴─────────────────┘
```

## 🚀 Démarrage Rapide

### 1. Configuration de l'environnement

```bash
# Cloner le repository
cd infrastructure/env

# Setup environnement de développement
chmod +x setup-env.sh
./setup-env.sh development

# Éditer les variables si nécessaire
nano .env.development
```

### 2. Lancement de l'infrastructure

```bash
# Démarrage complet
cd infrastructure
./deploy/deploy.sh development

# Ou manuellement avec Docker Compose
cd docker
docker-compose --env-file ../env/.env.development up -d
```

### 3. Vérification du déploiement

```bash
# Vérifier les services
docker-compose ps

# Tester l'API
curl http://localhost:8000/health

# Accéder à Grafana (monitoring)
open http://localhost:3000
```

## 📁 Structure de l'infrastructure

```
infrastructure/
├── docker/
│   └── docker-compose.yml          # Orchestration des services
├── env/
│   ├── .env.development           # Variables dev (généré)
│   ├── .env.staging              # Variables staging
│   ├── .env.example              # Template d'exemple
│   └── setup-env.sh              # Script de configuration
├── ci-cd/
│   └── github-actions.yml        # Pipeline CI/CD GitHub
├── database/
│   ├── init/
│   │   └── 01-init.sql          # Initialisation PostgreSQL
│   └── migrations/
│       ├── 001_create_tables.sql # Tables de base
│       └── 002_optimize_indexes.sql # Optimisations
├── monitoring/
│   └── prometheus.yml           # Configuration monitoring
├── ssl/
│   └── nginx.conf              # Configuration SSL/HTTPS
├── backup/
│   └── scripts/
│       ├── backup.sh          # Sauvegarde automatique
│       └── restore.sh         # Restauration
├── deploy/
│   └── deploy.sh              # Script de déploiement
└── README.md                  # Ce fichier
```

## 🔧 Environnements

### Development
- Base de données locale
- Logs détaillés activés
- CORS permissifs
- SSL auto-signé
- Rechargement automatique

### Staging
- Configuration proche prod
- SSL Let's Encrypt
- Monitoring activé
- Backups journaliers
- Tests d'intégration

### Production
- SSL certifié
- Rate limiting strict
- Monitoring avancé
- Backups multiples
- Haute disponibilité

## 🗄️ Base de Données

### Tables Principales
- `users` - Utilisateurs (coaches/clients)
- `coach_profiles` - Profils détaillés coaches  
- `bookings` - Réservations de séances
- `payments` - Paiements manuels
- `client_coach_relationships` - Relations commerciales

### Optimisations Incluses
- Index composites pour les requêtes fréquentes
- Partitioning par date pour les bookings
- Matérialized views pour les statistiques
- Triggers pour la cohérence des données

### Migrations

```bash
# Appliquer les migrations
cd infrastructure
docker-compose exec api python -m alembic upgrade head

# Créer une nouvelle migration
docker-compose exec api python -m alembic revision --autogenerate -m "description"
```

## 🔐 Sécurité

### Chiffrement
- Variables d'environnement sécurisées
- JWT pour l'authentification
- Passwords hashés (bcrypt)
- SSL/TLS pour toutes les communications

### Backup
- Sauvegardes chiffrées automatiques
- Rétention configurable
- Validation d'intégrité
- Restauration assistée

```bash
# Backup manuel
./backup/scripts/backup.sh

# Restauration
./backup/scripts/restore.sh -l  # Lister les backups
./backup/scripts/restore.sh mycoach_backup_20260303_120000.sql.gz
```

## 📊 Monitoring

### Métriques Disponibles
- Performance API (latence, erreurs)
- Usage base de données 
- Consommation mémoire/CPU
- Statistiques business (inscriptions, bookings)

### Alertes Configurées
- Taux d'erreur élevé (>5%)
- Connexions DB saturées (>80%)
- Espace disque faible (<10%)
- Services indisponibles

### Accès Monitoring

```bash
# Grafana (dashboards)
http://localhost:3000
# Admin: admin / (voir GRAFANA_ADMIN_PASSWORD)

# Prometheus (métriques brutes)  
http://localhost:9090

# Loki (logs centralisés)
http://localhost:3100
```

## 🚀 CI/CD GitHub Actions

### Pipeline Automatique
1. **Test** - Tests Python + Flutter
2. **Security** - Scan vulnérabilités  
3. **Build** - Images Docker
4. **Deploy Staging** - Sur branche `develop`
5. **Deploy Production** - Sur branche `main`

### Configuration GitHub
```bash
# Copier le workflow
cp ci-cd/github-actions.yml .github/workflows/ci-cd.yml

# Configurer les secrets GitHub
# Settings > Secrets and variables > Actions
```

### Secrets Requis
- `SSH_PRIVATE_KEY` - Clé SSH pour déploiement
- `STAGING_HOST` / `PRODUCTION_HOST` - IPs serveurs
- `SECRET_KEY_STAGING` / `SECRET_KEY_PRODUCTION` - Clés app
- `POSTGRES_PASSWORD_STAGING` / `POSTGRES_PASSWORD_PRODUCTION`
- `SLACK_WEBHOOK` (optionnel) - Notifications

## 📖 Utilisation

### Développement Local

```bash
# Premier setup
cd infrastructure
./env/setup-env.sh development
./deploy/deploy.sh development

# Développement quotidien  
docker-compose --env-file env/.env.development up -d
docker-compose logs -f api  # Voir les logs
```

### Tests

```bash
# Tests complets
cd app/backend
python -m pytest

cd app/flutter  
flutter test

# Tests d'intégration
curl http://localhost:8000/auth/register -d '{"email":"test@test.com","password":"test123","role":"coach"}'
```

### Déploiement Staging

```bash
# Manuel
./deploy/deploy.sh staging

# Automatique (push sur develop)
git push origin develop
```

### Déploiement Production

```bash
# Manual avec confirmation
./deploy/deploy.sh production

# Avec backup forcé
./deploy/deploy.sh --force production

# Automatique (push sur main)  
git push origin main
```

## 🔧 Maintenance

### Logs
```bash
# Logs en temps réel
docker-compose logs -f

# Logs spécifiques
docker-compose logs api
docker-compose logs postgres
docker-compose logs nginx
```

### Nettoyage
```bash
# Nettoyer les images
docker system prune -a

# Nettoyer les volumes (⚠️ perte de données)
docker-compose down -v
```

### Mise à jour
```bash
# Mettre à jour les images
docker-compose pull
docker-compose up -d

# Redémarrer un service
docker-compose restart api
```

## ⚠️ Troubleshooting

### Problèmes Fréquents

**Service ne démarre pas**
```bash
# Vérifier les logs
docker-compose logs [service]

# Vérifier la config
docker-compose config

# Redémarrer proprement
docker-compose down && docker-compose up -d
```

**Base de données inaccessible**
```bash
# Vérifier si PostgreSQL est prêt
docker-compose exec postgres pg_isready -U mycoach_user

# Vérifier les connexions
docker-compose exec postgres psql -U mycoach_user -d mycoach_dev -c "SELECT 1;"
```

**Erreurs SSL/HTTPS**
```bash
# Générer certificats auto-signés pour dev
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/private/localhost.key \
  -out ssl/certs/localhost.crt
```

**Performance dégradée**
```bash
# Vérifier l'usage ressources
docker stats

# Analyser les requêtes lentes PostgreSQL
docker-compose exec postgres psql -U mycoach_user -d mycoach_dev \
  -c "SELECT query, mean_time, calls FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;"
```

## 📞 Support

### Contacts Équipe
- **Sysadmin** : Canal Discord `#sysadmin`
- **Dev Backend** : Canal Discord `#dev-python`  
- **QA** : Canal Discord `#qa-flutter`

### Documentation
- [API Documentation](http://localhost:8000/docs) (Swagger)
- [Database Schema](./database/migrations/) 
- [Monitoring Dashboards](http://localhost:3000)

### Liens Utiles
- [Docker Documentation](https://docs.docker.com/)
- [PostgreSQL Tuning](https://pgtune.leopard.in.ua/)
- [Nginx Configuration](https://nginx.org/en/docs/)
- [Prometheus Queries](https://prometheus.io/docs/prometheus/latest/querying/)

---

## ✅ Checklist de Déploiement

### Development ✓
- [x] Docker Compose fonctionnel
- [x] Base de données avec données de test
- [x] API accessible sur port 8000
- [x] Monitoring Grafana sur port 3000
- [x] SSL auto-signé configuré

### Staging ✓
- [x] Variables d'environnement sécurisées  
- [x] SSL Let's Encrypt configuré
- [x] Backups automatiques activés
- [x] CI/CD pipeline fonctionnel
- [x] Health checks configurés

### Production ✓  
- [x] Monitoring et alertes opérationnels
- [x] Haute disponibilité configurée
- [x] Sauvegardes multiples validées
- [x] Sécurité renforcée (rate limiting, etc.)
- [x] Notifications équipe configurées

**Infrastructure MyCoach Phase 1 - Prête pour le développement ! 🚀**