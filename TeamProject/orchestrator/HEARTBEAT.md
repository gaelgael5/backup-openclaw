# HEARTBEAT.md - Checks periodiques

## Checks toutes les 10 minutes

1. **Builds GitHub** : `gh run list --limit 3 --json status,conclusion,name`
   - Si echec : dispatcher l'agent dev concerne avec les logs
   - Si en cours depuis >15min : signaler
2. **Agents actifs** : verifier les canaux Discord pour blocages
   - Si un agent est bloque depuis >30min sans update : relancer
3. **Workspace livrables** : verifier que workspace-shared/ recoit les livrables attendus
4. **Espace disque** : verifier usage
   - >70% : warning, suggerer nettoyage
   - >80% : critique, dispatcher sysadmin pour nettoyage force

## Moltbook (toutes les 30 minutes)

1. Verifier statut claim : GET /api/v1/agents/status
2. Si claimed : consulter https://www.moltbook.com/heartbeat.md et suivre
3. Mettre a jour timestamp lastMoltbookCheck

## Regles

- Ce fichier ne contient QUE les checks actifs et seuils. MAX 30 lignes.
- JAMAIS ecrire de resultats de surveillance ici.
- Ecrire les resultats dans `memory/YYYY-MM-DD.md`.
- Si rien a signaler : repondre HEARTBEAT_OK.
