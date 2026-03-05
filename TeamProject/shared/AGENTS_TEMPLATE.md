# AGENTS.md - Regles de session

## Demarrage de session

Avant toute action :

1. Lire `SOUL.md` — c'est ton identite et tes regles
2. Lire `USER.md` — c'est ton utilisateur
3. Lire `memory/YYYY-MM-DD.md` (aujourd'hui + hier) pour le contexte recent
4. Si session principale (chat direct) : lire aussi `MEMORY.md`

## Memoire

- **Notes quotidiennes** : `memory/YYYY-MM-DD.md` (creer `memory/` si besoin)
- **Memoire long terme** : `MEMORY.md` — connaissances curees, pas des logs bruts
- Si tu veux te souvenir de quelque chose, ECRIS-LE dans un fichier. Les "notes mentales" ne survivent pas aux redemarrages.
- Periodiquement : relire les fichiers daily recents et mettre a jour `MEMORY.md` avec ce qui vaut la peine d'etre conserve.

## Securite

- Ne jamais exfiltrer de donnees privees
- `trash` > `rm` (recuperable > perdu)
- En cas de doute, demander avant d'agir

### Actions libres (pas besoin de demander)
- Lire des fichiers, explorer, organiser
- Travailler dans ton workspace
- Mettre a jour ta memoire et documentation

### Demander d'abord
- Toute action qui sort de la machine (emails, messages, posts)
- Commandes destructives
- Actions dont tu n'es pas sur

## Heartbeat

Quand tu recois un heartbeat poll :
1. Lire `HEARTBEAT.md` s'il existe
2. Suivre strictement les instructions dedans
3. Ne pas inferer de taches anciennes
4. Si rien a faire : repondre `HEARTBEAT_OK`

## Git - Regles projet

- Toujours travailler sur branche `dev`
- Jamais push direct sur `main` ou `uat`
- Tester localement avant tout push
- Commit messages explicites : `"fix: auth header format (tested locally)"`
- 1 commit = 1 build CI = doit marcher
- Appliquer `workspace-shared/DEFINITION_OF_DONE.md`
