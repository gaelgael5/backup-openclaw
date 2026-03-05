# CICD_WORKFLOW.md - Workflow CI/CD Automatisé

## 🚨 NOUVELLE DEFINITION OF DONE - OBLIGATOIRE

**Terminé = Code fonctionnel ET pipeline vert ✅**

## Workflow Post-Push (Automatique)

### 1. Push Code → GitHub
```bash
git add .
git commit -m "message"
git push origin main
```

### 2. Attendre démarrage CI (30s)
```bash
sleep 30
```

### 3. Polling Statut CI (Max 10min)
```bash
# Vérifier derniers runs
curl -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs?per_page=5"

# Loop toutes les 30s jusqu'à completion
while [ "$status" != "completed" ]; do
  sleep 30
  # Re-check status
done
```

### 4. Analyse Résultats

#### ✅ Succès → Mission TERMINÉE
```json
{
  "status": "completed",
  "conclusion": "success"
}
```

#### ❌ Échec → Correction Automatique
```json
{
  "status": "completed", 
  "conclusion": "failure"
}
```

**Actions automatiques:**
1. **Télécharger logs complets**
2. **Analyser erreurs** (Flutter analyze, build, tests)
3. **Corriger immédiatement** sans demander permission
4. **Re-push** automatique
5. **Répéter boucle** (max 3 tentatives)

### 5. Escalade (Après 3 échecs)
- **Documenter** toutes les tentatives de correction
- **Inclure logs** complets des échecs
- **Signaler problème** avec contexte technique complet
- **Demander aide humaine**

## Gestion Erreurs Communes

### Flutter Analyze
```bash
flutter analyze --fatal-infos
# Correction automatique des warnings/errors
```

### Build Errors  
```bash
flutter build apk --debug
# Correction dépendances/imports
```

### Tests Unitaires
```bash
flutter test
# Correction tests cassés
```

## API Calls Concrets

### Vérifier Status Run
```bash
curl -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs/$(git rev-parse HEAD)"
```

### Détails Jobs
```bash
curl -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs/{run_id}/jobs"
```

### Logs Complets
```bash
curl -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/gaelgael5/my-trainers/actions/runs/{run_id}/logs" \
     -o ci_logs.zip
```

## Règles Non Négociables

### ❌ INTERDIT
- Déclarer mission terminée sans vérifier CI
- Ignorer un build en échec  
- Laisser un CI rouge sans correction
- Dépasser 3 tentatives sans escalade

### ✅ OBLIGATOIRE
- Polling automatique post-push
- Lecture complète logs d'échec
- Correction immédiate sans permission
- Documentation corrections appliquées
- Escalade après 3 échecs avec contexte

## État Monitoring

### Variables à tracker
```json
{
  "last_push_sha": "abc123...",
  "ci_status": "in_progress|success|failure",
  "attempt_count": 2,
  "last_check_time": "2026-03-05T07:05:00Z",
  "logs_analyzed": true,
  "corrections_applied": ["flutter_analyze", "build_fix"]
}
```

**Objectif: ZÉRO BUILD CASSÉ - Pipeline stable garantie ✅**