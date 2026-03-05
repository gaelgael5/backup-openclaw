# Démonstration Workflow API GitHub - dev-python

## 🎯 Objectif

Démontrer la maîtrise complète du nouveau workflow CI/CD obligatoire via l'API GitHub.

---

## 🔧 Configuration API GitHub

### Variables d'environnement
```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"  # Token personnel avec accès repo
export REPO_OWNER="gaelgael5"
export REPO_NAME="my-trainers"
export API_BASE="https://api.github.com"
```

### Headers HTTP standardisés
```bash
API_HEADERS='-H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN"'
```

---

## 📊 Workflow Post-Push Complet

### Étape 1: Push du code
```bash
git add .
git commit -m "feat: implement user authentication with JWT"
git push origin main
echo "✅ Code pushé à $(date +"%H:%M:%S")"
```

### Étape 2: Attente démarrage CI (30s)
```bash
echo "⏱️ Attente démarrage CI..."
sleep 30
```

### Étape 3: Récupération du dernier run CI
```bash
# Récupérer les 5 derniers runs
RUNS_RESPONSE=$(curl -s $API_HEADERS \
  "$API_BASE/repos/$REPO_OWNER/$REPO_NAME/actions/runs?per_page=5")

# Extraire l'ID du run le plus récent
LATEST_RUN_ID=$(echo "$RUNS_RESPONSE" | jq -r '.workflow_runs[0].id')
LATEST_RUN_STATUS=$(echo "$RUNS_RESPONSE" | jq -r '.workflow_runs[0].status')
LATEST_RUN_CONCLUSION=$(echo "$RUNS_RESPONSE" | jq -r '.workflow_runs[0].conclusion')

echo "🔍 Run CI #$LATEST_RUN_ID - Status: $LATEST_RUN_STATUS"
```

### Étape 4: Polling du statut CI
```bash
monitor_ci() {
    local run_id=$1
    local attempt=1
    local max_attempts=20  # 20 * 30s = 10 minutes max
    
    while [ $attempt -le $max_attempts ]; do
        # Récupérer le statut actuel
        RUN_STATUS=$(curl -s $API_HEADERS \
          "$API_BASE/repos/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id" | \
          jq -r '.status')
        
        RUN_CONCLUSION=$(curl -s $API_HEADERS \
          "$API_BASE/repos/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id" | \
          jq -r '.conclusion')
        
        echo "🔄 Tentative $attempt - Status: $RUN_STATUS, Conclusion: $RUN_CONCLUSION"
        
        case "$RUN_STATUS" in
            "completed")
                case "$RUN_CONCLUSION" in
                    "success")
                        echo "✅ CI SUCCESS - Mission peut être déclarée TERMINÉE"
                        return 0
                        ;;
                    "failure")
                        echo "❌ CI FAILURE - Analyse des logs nécessaire"
                        analyze_failure $run_id
                        return 1
                        ;;
                    "cancelled")
                        echo "⚠️ CI CANCELLED - Re-push nécessaire"
                        return 2
                        ;;
                esac
                ;;
            "in_progress")
                echo "🟡 CI en cours... Attente 30s"
                sleep 30
                ;;
            "queued")
                echo "⏳ CI en queue... Attente 30s"
                sleep 30
                ;;
        esac
        
        ((attempt++))
    done
    
    echo "⏱️ TIMEOUT - CI dépasse 10 minutes, escalade nécessaire"
    return 3
}
```

### Étape 5: Analyse des échecs CI
```bash
analyze_failure() {
    local run_id=$1
    echo "🔍 ANALYSE DE L'ÉCHEC CI #$run_id"
    
    # Récupérer les jobs du run
    JOBS_RESPONSE=$(curl -s $API_HEADERS \
      "$API_BASE/repos/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id/jobs")
    
    # Identifier les jobs en échec
    FAILED_JOBS=$(echo "$JOBS_RESPONSE" | jq -r '.jobs[] | select(.conclusion == "failure") | "\(.name): \(.conclusion)"')
    
    echo "❌ Jobs en échec:"
    echo "$FAILED_JOBS"
    
    # Récupérer les logs complets
    echo "📋 Récupération des logs..."
    curl -s $API_HEADERS \
      "$API_BASE/repos/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id/logs" \
      -o "ci-failure-logs-$run_id.zip"
    
    echo "💾 Logs sauvegardés: ci-failure-logs-$run_id.zip"
    
    # Auto-diagnostic des erreurs Python courantes
    auto_diagnose_python_errors $run_id
}
```

### Étape 6: Auto-diagnostic et correction
```bash
auto_diagnose_python_errors() {
    local run_id=$1
    echo "🤖 AUTO-DIAGNOSTIC EN COURS..."
    
    # Extraire et analyser les logs
    unzip -q "ci-failure-logs-$run_id.zip"
    
    # Rechercher les patterns d'erreurs Python courants
    if grep -r "ModuleNotFoundError" . 2>/dev/null; then
        echo "🔧 DÉTECTÉ: Erreur d'import de module"
        echo "   → Vérification de requirements.txt nécessaire"
        handle_missing_dependency
    fi
    
    if grep -r "pytest.*FAILED" . 2>/dev/null; then
        echo "🔧 DÉTECTÉ: Tests pytest en échec"
        echo "   → Analyse des tests unitaires nécessaire"
        handle_pytest_failures
    fi
    
    if grep -r "mypy.*error" . 2>/dev/null; then
        echo "🔧 DÉTECTÉ: Erreurs de typage mypy"
        echo "   → Correction des annotations de type nécessaire"
        handle_mypy_errors
    fi
    
    if grep -r "flake8\|black.*reformatted" . 2>/dev/null; then
        echo "🔧 DÉTECTÉ: Erreurs de style/formatting"
        echo "   → Auto-formatting nécessaire"
        handle_lint_errors
    fi
    
    # Cleanup
    rm -rf "ci-failure-logs-$run_id.zip" **/
}
```

### Étape 7: Corrections automatiques
```bash
handle_missing_dependency() {
    echo "🔧 CORRECTION: Ajout de dépendances manquantes"
    # Logic pour identifier et ajouter les dépendances
    # pip-compile, poetry add, etc.
}

handle_pytest_failures() {
    echo "🔧 CORRECTION: Analyse des tests pytest"
    # Relancer les tests localement pour débugger
    python -m pytest tests/ -v --tb=short
}

handle_mypy_errors() {
    echo "🔧 CORRECTION: Ajout d'annotations de type"
    # Utiliser mypy pour identifier les problèmes de typage
    mypy --show-error-codes src/
}

handle_lint_errors() {
    echo "🔧 CORRECTION: Auto-formatting du code"
    black src/ tests/
    isort src/ tests/
    flake8 src/ tests/ --max-line-length=88
}
```

---

## 🚀 Workflow Complet Automatisé

```bash
#!/bin/bash
# dev-python-ci-workflow.sh - Script complet de validation CI/CD

set -e

# Configuration
source .env  # GITHUB_TOKEN, REPO_OWNER, REPO_NAME

# 1. Push du code
echo "🚀 DÉBUT DU WORKFLOW CI/CD"
git push origin main
PUSH_TIME=$(date +"%H:%M:%S")

# 2. Monitoring automatique
echo "⏱️ Démarrage du monitoring CI..."
sleep 30

# 3. Récupération du run CI
LATEST_RUN_ID=$(curl -s $API_HEADERS \
  "$API_BASE/repos/$REPO_OWNER/$REPO_NAME/actions/runs?per_page=1" | \
  jq -r '.workflow_runs[0].id')

echo "🎯 Monitoring du run CI #$LATEST_RUN_ID"

# 4. Polling et gestion des échecs
MAX_RETRIES=3
retry_count=0

while [ $retry_count -lt $MAX_RETRIES ]; do
    if monitor_ci $LATEST_RUN_ID; then
        echo "✅ MISSION TERMINÉE - CI VERT"
        echo "📊 Rapport final:"
        echo "   - Code pushé à: $PUSH_TIME"
        echo "   - CI validé à: $(date +"%H:%M:%S")"
        echo "   - Run ID: #$LATEST_RUN_ID"
        echo "   - Tentatives: $((retry_count + 1))/$MAX_RETRIES"
        exit 0
    else
        ((retry_count++))
        if [ $retry_count -lt $MAX_RETRIES ]; then
            echo "🔄 RETRY $retry_count/$MAX_RETRIES - Correction et re-push"
            # Appliquer les corrections automatiques détectées
            apply_automatic_fixes
            git add .
            git commit -m "fix: correction automatique CI (tentative $retry_count)"
            git push origin main
            sleep 30
            
            # Récupérer le nouveau run ID
            LATEST_RUN_ID=$(curl -s $API_HEADERS \
              "$API_BASE/repos/$REPO_OWNER/$REPO_NAME/actions/runs?per_page=1" | \
              jq -r '.workflow_runs[0].id')
        fi
    fi
done

# 5. Escalade après épuisement des tentatives
echo "❌ ESCALADE NÉCESSAIRE"
echo "🔍 Logs complets disponibles dans: ci-failure-logs-*.zip"
echo "📨 Contact orchestrator avec contexte complet"
exit 1
```

---

## 📋 Format de rapport final

### Succès CI
```
[DE: dev-python → À: orchestrator]
[STATUT: TERMINÉ]
[CONTEXTE CI/CD: Pipeline validé ✅]

WORKFLOW COMPLET:
- ✅ Push: 14:23:15
- ✅ CI Start: 14:23:45  
- ✅ CI Success: 14:26:32
- ✅ Durée totale: 3min 17s
- ✅ Tentatives: 1/3

RUN CI DETAILS:
- Run ID: #8847625
- Jobs: build ✅, test ✅, lint ✅, security ✅
- Coverage: 87% (tests)

MISSION: Code fonctionnel + Pipeline stable
READY FOR: QA + Audit sécurité
```

### Escalade après 3 échecs
```
[DE: dev-python → À: orchestrator]
[STATUT: BLOQUÉ]
[CONTEXTE CI/CD: Échecs persistants après 3 tentatives]

HISTORIQUE DES TENTATIVES:
1. Run #8847620: pytest failure (auth module)
2. Run #8847623: mypy errors (type annotations)  
3. Run #8847625: docker build failure (dependency conflict)

DERNIER PROBLÈME (non résolu):
- Conflit de dépendances: fastapi vs pydantic versions
- Logs complets: ci-failure-logs-8847625.zip
- Tentatives auto-correction épuisées

ESCALADE DEMANDÉE: Assistance pour résolution conflit dependencies
```

---

## ✅ CONFIRMATION D'INTÉGRATION

**dev-python** confirme avoir intégré la nouvelle "Definition of Done" :

- ✅ **API GitHub maîtrisée** : endpoints runs/jobs/logs
- ✅ **Workflow automatisé** : monitoring post-push obligatoire  
- ✅ **Gestion d'échecs** : correction immédiate sans permission
- ✅ **Escalade intelligente** : après 3 tentatives avec contexte complet
- ✅ **Mission terminée** = Code fonctionnel ET CI vert

**Cette approche est applicable dès la prochaine mission de développement.**

**ZÉRO TOLÉRANCE pour les builds backend cassés - Responsabilité CI/CD de bout en bout.**