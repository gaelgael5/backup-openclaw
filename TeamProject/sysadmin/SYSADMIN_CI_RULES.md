# 🚨 SYSADMIN - NOUVELLE DEFINITION OF DONE CI/CD

**VERSION**: 2025-03-05  
**STATUT**: ACTIF - Applicable immédiatement  

## 🎯 RÈGLE FONDAMENTALE

### ❌ ANCIEN: Terminé = Code/workflow pushé sur GitHub  
### ✅ NOUVEAU: Terminé = Code pushé ET GitHub Actions CI VERT

**ZÉRO TOLÉRANCE**: Aucune mission sysadmin n'est terminée tant que le CI n'est pas vert ✅

---

## 📊 COMPÉTENCES API GITHUB OBLIGATOIRES

### API Endpoints de surveillance CI

```bash
# 1. Lister les runs GitHub Actions
GET /repos/{owner}/{repo}/actions/runs?per_page=5
curl -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/{owner}/{repo}/actions/runs?per_page=5"

# 2. Détails d'un run spécifique  
GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs
curl -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/{owner}/{repo}/actions/runs/{run_id}/jobs"

# 3. Logs d'erreur complets
GET /repos/{owner}/{repo}/actions/runs/{run_id}/logs  
curl -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/{owner}/{repo}/actions/runs/{run_id}/logs"
```

### Headers requis
- `Accept: application/vnd.github+json`
- `Authorization: Bearer $GITHUB_TOKEN` (si repo privé)
- `X-GitHub-Api-Version: 2022-11-28`

---

## 🔄 WORKFLOW POST-PUSH OBLIGATOIRE

### Étapes à exécuter systématiquement

```
1. Push code/workflow vers GitHub
   ↓
2. Attendre 30s (démarrage CI)
   ↓
3. Poll statut CI via API GitHub (toutes les 30s)
   ├─ En cours (status: "in_progress") → Re-poll
   ├─ Succès (conclusion: "success") → ✅ MISSION TERMINÉE
   └─ Échec (conclusion: "failure") → Lire logs → Corriger → Re-push
   ↓
4. Limite 3 tentatives de correction
   └─ Si échec après 3 tentatives → Escalader avec logs complets
```

### Statuts GitHub Actions à surveiller

| Status | Conclusion | Action |
|--------|------------|---------|
| `queued` | `null` | Attendre |
| `in_progress` | `null` | Continuer à poll |
| `completed` | `success` | ✅ TERMINÉ |
| `completed` | `failure` | ❌ Lire logs + Corriger |
| `completed` | `cancelled` | ⚠️ Investiguer cause |
| `completed` | `timed_out` | ⚠️ Optimiser workflow |

---

## ⚙️ CORRECTIONS AUTOMATIQUES OBLIGATOIRES

### Erreurs YAML (GitHub Actions workflows)
- **Syntaxe YAML**: Indentation, structure, caractères spéciaux
- **Structure workflow**: `name`, `on`, `jobs`, `steps`
- **Actions invalides**: Versions inexistantes, paramètres incorrects

### Erreurs Permissions  
- **GITHUB_TOKEN**: Permissions manquantes (`contents: read/write`, `actions: read`)
- **Secrets**: Variables d'environnement non définies
- **Environments**: Restrictions de déploiement

### Erreurs Infrastructure
- **Docker**: Build failures, registry auth, multi-stage issues
- **Dependencies**: Version conflicts, security vulnerabilities  
- **Services**: Base de données, Redis, services externes dans CI

### Auto-corrections typiques

```yaml
# ❌ ERREUR: Indentation incorrecte
on:
push:
  branches: [ main ]

# ✅ CORRECTION: Indentation correcte  
on:
  push:
    branches: [ main ]

# ❌ ERREUR: Action inexistante
- uses: actions/checkout@v5

# ✅ CORRECTION: Version existante
- uses: actions/checkout@v4

# ❌ ERREUR: Permission manquante
jobs:
  deploy:
    runs-on: ubuntu-latest

# ✅ CORRECTION: Permission ajoutée
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
```

---

## 🚨 RÈGLES NON NÉGOCIABLES

### ❌ ABSOLUMENT INTERDIT

1. **Déclarer mission terminée** sans vérifier CI vert
2. **Ignorer un workflow en échec** ("ça marche en local")  
3. **Laisser un CI rouge** sans correction
4. **Dépasser 3 tentatives** sans escalade avec logs
5. **Pousser du code non testé** en production

### ✅ ABSOLUMENT OBLIGATOIRE

1. **Polling automatique** post-push (max 10min d'attente)
2. **Lecture complète des logs** en cas d'échec
3. **Correction immédiate** sans attendre instruction
4. **Documentation des corrections** dans commit message
5. **Escalade intelligente** après 3 échecs avec contexte complet

---

## 📝 EXEMPLE DE WORKFLOW COMPLET

### 1. Push initial
```bash
git add .
git commit -m "feat: add new deployment workflow"
git push origin main
```

### 2. Surveillance automatique
```bash
# Attendre 30s puis vérifier
sleep 30

# Récupérer le dernier run  
curl -s -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs?per_page=1" \
     | jq -r '.workflow_runs[0] | "\(.status) \(.conclusion) \(.id)"'

# Exemple réponse: "in_progress null 12345678"
```

### 3. Polling jusqu'à completion
```bash
while true; do
  status=$(curl -s -H "Accept: application/vnd.github+json" \
           "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs/12345678" \
           | jq -r '.status')
  
  if [ "$status" = "completed" ]; then
    conclusion=$(curl -s -H "Accept: application/vnd.github+json" \
                 "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs/12345678" \
                 | jq -r '.conclusion')
    
    if [ "$conclusion" = "success" ]; then
      echo "✅ CI VERT - Mission terminée"
      break
    else
      echo "❌ CI ROUGE - Analyse des logs..."
      # Télécharger et analyser les logs
      break
    fi
  fi
  
  echo "🔄 CI en cours... (status: $status)"
  sleep 30
done
```

### 4. En cas d'échec - Correction automatique
```bash
# Télécharger les logs d'erreur
curl -L -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs/12345678/logs" \
     -o logs.zip

# Analyser l'erreur et corriger automatiquement
# Exemple: Erreur YAML détectée -> Corriger -> Re-push
```

---

## 🎯 OBJECTIFS MESURABLES

### KPI de réussite sysadmin
- **100%** des workflows infrastructure fonctionnels  
- **0%** de CI rouge persistant (>1h)
- **≤3 tentatives** pour corriger un échec CI
- **≤10min** entre push et validation CI vert

### Escalade après 3 échecs
Si après 3 tentatives de correction automatique le CI reste rouge :

```
🚨 ESCALADE SYSADMIN - CI PERSISTANT EN ÉCHEC

Repository: {owner}/{repo}
Run ID: {run_id}  
Erreur principale: {error_summary}
Tentatives: 3/3 (échec)

Logs complets: [logs.zip]
Commit défaillant: {commit_sha}
Workflow: {workflow_name}

DEMANDE AIDE TECHNIQUE - Problème complexe détecté
```

---

## 🔧 INTÉGRATION AVEC GITHUB CLI

Pour faciliter l'automatisation, utiliser `gh` CLI :

```bash
# Vérifier statut du dernier run
gh run list --limit 1 --json status,conclusion,databaseId

# Voir logs d'un run spécifique  
gh run view 12345678 --log

# Re-déclencher un workflow failed
gh workflow run main.yml
```

---

**✅ CONFIRMATION D'INTÉGRATION**: Ces règles sont désormais actives pour toutes mes missions sysadmin.  

**🚀 PRÊT POUR DÉMONSTRATION**: API GitHub maîtrisée, workflow de polling implémentable immédiatement.