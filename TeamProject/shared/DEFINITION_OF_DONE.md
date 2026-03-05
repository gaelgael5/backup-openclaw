# Definition of Done - Regles communes

## Regle fondamentale

**TERMINE = Code pushe + GitHub Actions CI VERT**

```
FAUX : "Termine" = code ecrit + fichiers crees
VRAI  : "Termine" = code pushe + TOUS les workflows CI GREEN
```

---

## Workflow post-push obligatoire

1. Valider localement (tests + lint de ton stack)
2. Push vers la branche cible
3. Attendre 30s puis poll CI via `gh run list --limit 1`
4. Si `in_progress` : re-poll toutes les 30s (max 10 min)
5. Si `success` : signaler TERMINE avec preuve (run ID + commit SHA)
6. Si `failure` : lire logs (`gh run view <id> --log`), corriger, re-push
7. Max 3 tentatives de correction. Au-dela : escalade

---

## Commandes de reference

```bash
# Lister le dernier run
gh run list --limit 1 --json status,conclusion,databaseId

# Surveiller un run en cours
gh run watch <run_id>

# Lire les logs d'un echec
gh run view <run_id> --log

# Status des PRs
gh pr status
```

---

## Communication avec l'orchestrateur

Utiliser ce format pour les rapports de statut :

```
[DE: <agent> -> A: orchestrator]
[STATUT: EN COURS] - Code pushe, CI en cours (run #<id>)
[STATUT: EN COURS] - CI echoue, correction en cours (tentative <n>/3)
[STATUT: TERMINE]  - CI VERT confirme (run #<id>, commit <sha>)
[STATUT: BLOQUE]   - 3 echecs CI, escalade necessaire
```

---

## Regles non negociables

### Interdit
- Declarer TERMINE sans CI vert confirme
- Ignorer un workflow en echec
- Laisser un CI rouge sans correction
- Depasser 3 tentatives sans escalade avec logs

### Obligatoire
- Poll automatique apres chaque push
- Lecture complete des logs en cas d'echec
- Correction immediate sans attendre instruction
- Documentation des corrections dans le commit message
- Escalade apres 3 echecs avec contexte complet

---

## Escalade apres 3 echecs

```
[DE: <agent> -> A: orchestrator]
[STATUT: BLOQUE]
[TYPE: ESCALADE-CI]

Repository: <owner>/<repo>
Run ID: <run_id>
Erreur principale: <resume en 1 ligne>
Tentatives: 3/3 (echec)
Commit: <sha>
Workflow: <workflow_name>

Logs joints ou commande pour les lire :
gh run view <run_id> --log
```

---

## Checklist avant STATUT: TERMINE

- [ ] Tests locaux passes (stack-specific)
- [ ] Code pushe sur branche cible
- [ ] GitHub Actions declenche
- [ ] CI terminee avec succes
- [ ] Aucune regression detectee
- [ ] Livrable confirme dans workspace-shared/ (si applicable)
