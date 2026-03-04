# 🔄 OpenClaw Agents Backup Repository

Ce repository contient les sauvegardes automatisées des configurations et fichiers markdown des agents OpenClaw.

## 📋 Description

Ce projet sert à **préserver et synchroniser** les configurations des agents OpenClaw entre différents environnements. Il sauvegarde automatiquement :

Comment automatiser la sauvegarde.
```
Tout les jours à minuit : descend le repository github "https://github.com/gaelgael5/backup-openclaw/tree/main", execute le fichier "backup-agents-markdown.sh" à la racine et commit les changements.
```


- ✅ **Configurations agents** (SOUL.md, AGENTS.md, IDENTITY.md, etc.)
- ✅ **Profils experts** et paramètres comportementaux
- ✅ **Documentation projet** (livrables, rapports, guides)
- ✅ **Scripts et procédures** développés par les agents

## 🗂️ Structure

```
backup-openclaw/
├── backup-agents-markdown.sh    # Script de sauvegarde automatique
├── TeamProject/                 # Sauvegardes organisées par agent
│   ├── dev-flutter/             # Agent développement Flutter
│   ├── dev-python/              # Agent développement Python/Backend  
│   ├── orchestrator/            # Agent coordinateur principal
│   ├── sysadmin/                # Agent infrastructure/déploiement
│   ├── ux-researcher/           # Agent recherche UX/design
│   ├── tester-flutter-qa/       # Agent qualité/tests Flutter
│   ├── product/                 # Agent product management
│   ├── strategist/              # Agent analyse stratégique
│   ├── marketer/                # Agent marketing/acquisition
│   └── legal/                   # Agent juridique/conformité
└── README.md                    # Ce fichier
```

## 🚀 Comment Sauvegarder

### Sauvegarde Manuelle

```bash
# 1. Se positionner dans le répertoire backup-openclaw
cd /path/to/backup-openclaw

# 2. Exécuter le script de sauvegarde
./backup-agents-markdown.sh

# 3. Commiter les changements
git add -A
git commit -m "feat: Backup agents $(date '+%Y-%m-%d %H:%M')"

# 4. Pousser vers GitHub
git push origin main
```

### Sauvegarde depuis OpenClaw Orchestrator

```bash
# Via l'orchestrator OpenClaw
cd /root/.openclaw/workspace-orchestrator/backup-openclaw
./backup-agents-markdown.sh
git add -A && git commit -m "feat: Backup automatique agents OpenClaw $(date '+%Y-%m-%d %H:%M')"
git push origin main
```

## 📁 Fichiers Sauvegardés

Le script `backup-agents-markdown.sh` collecte **uniquement les fichiers .md en MAJUSCULES** depuis les workspaces des agents :

### 📋 **Fichiers de Configuration**
- `AGENTS.md` - Configuration comportementale agent
- `SOUL.md` - Personnalité et règles de fonctionnement  
- `IDENTITY.md` - Identité et rôle de l'agent
- `TOOLS.md` - Notes personnelles d'outils
- `HEARTBEAT.md` - Configuration surveillance
- `USER.md` - Informations utilisateur

### 📊 **Documentation Projet**  
- `*_REPORT.md` - Rapports de livraison
- `*_SPECS.md` - Spécifications techniques
- `*_DELIVERY*.md` - Livrables et résultats
- `README.md` - Documentation générale

### 🔧 **Profils Experts**
- `*_PROFILE.md` - Profils de compétences avancées
- `*_ANALYSIS.md` - Analyses techniques approfondies

## 🎯 Règles de Filtrage

- ✅ **Inclus** : Fichiers .md avec noms en **MAJUSCULES**
- ❌ **Exclus** : Fichiers .md en minuscules (docs techniques temporaires)
- ❌ **Exclus** : Sous-dossiers et arborescences complexes
- ✅ **Inclus** : Fichiers racine des workspaces agents uniquement

## 📊 Statistiques

Dernière sauvegarde : **2026-03-04 22:29**
- **11 agents** sauvegardés
- **114 fichiers markdown** collectés  
- **Configuration complète** préservée

## 🛠️ Maintenance

### Exécution Périodique

Il est recommandé d'exécuter la sauvegarde :
- ✅ **Après modifications importantes** des configurations agents
- ✅ **Fin de projet/mission** pour archivage
- ✅ **Avant mises à jour** OpenClaw importantes
- ✅ **Hebdomadairement** pour synchronisation régulière

### Vérification Intégrité

```bash
# Vérifier que tous les agents ont été sauvegardés
ls -la TeamProject/

# Vérifier le nombre de fichiers par agent
find TeamProject/ -name "*.md" | wc -l
```

## 🔗 Liens Utiles

- **Projet principal** : [my-trainers](https://github.com/gaelgael5/my-trainers)
- **OpenClaw Documentation** : [docs.openclaw.ai](https://docs.openclaw.ai)
- **Community Discord** : [OpenClaw Discord](https://discord.com/invite/clawd)

## ⚖️ Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

**📝 Note :** Ce repository contient les configurations et la documentation des agents OpenClaw, pas le code source applicatif qui se trouve dans le repository principal my-trainers.
