# Definition of Done - Agent dev-python

## 🎯 RÈGLES ABSOLUES CI/CD

### ✅ Definition of Done activée

Une tâche N'EST PAS TERMINÉE tant que :
1. **Code pushé** sur la branche cible
2. **GitHub Actions CI au VERT** ✅ 

**ÉCHEC = RETOUR EN COURS**

### 🚀 Workflow opérationnel 

1. **Push** → GitHub Actions déclenché automatiquement
2. **Poll CI** → Surveiller via API GitHub (skill `github`)  
3. **Corriger échecs** → Debug + fix local puis re-push
4. **Re-push** → Répéter jusqu'au VERT
5. **TERMINÉ** seulement quand CI vert confirmé

### 📊 Compétences API GitHub intégrées

- **Monitoring** : Surveiller le statut des Actions via `gh run list`
- **Polling** : Vérifier périodiquement les builds en cours via `gh run watch`
- **Correction automatique** : Analyser les logs d'échec via `gh run view --log`
- **Status check** : Confirmer le statut final via `gh pr status`

### 🔥 Règles de zéro tolérance

- **Zéro build backend cassé** en production
- **Escalade après 3 échecs** → signaler blocage à l'orchestrateur
- **1 commit = 1 CI run = DOIT MARCHER**
- **Tests locaux OBLIGATOIRES** avant tout push :
  ```bash
  python -m pytest tests/
  python -m mypy src/
  python -m black --check .
  python -m isort --check-only .
  ```

### 💡 Intégration avec l'orchestrateur

```
[DE: dev-python → À: orchestrator]
[STATUT: EN COURS] - Code pushé, CI en cours (run #1234)
[STATUT: EN COURS] - CI échoué, correction en cours (tentative 2/3)
[STATUT: TERMINÉ] - CI VERT confirmé ✅ (run #1234, commit abc123)
[STATUT: BLOQUÉ] - 3 échecs CI, escalade nécessaire
```

### 📋 Checklist avant STATUT: TERMINÉ

- [ ] Code testé localement (pytest + mypy + black + isort)
- [ ] Code pushé sur branche cible
- [ ] GitHub Actions déclenchée
- [ ] CI terminée avec succès ✅
- [ ] Aucune régression détectée
- [ ] Livrable confirmé dans workspace-shared/

**RAPPEL** : TERMINÉ = Code pushé + CI VERT. Pas d'exception.