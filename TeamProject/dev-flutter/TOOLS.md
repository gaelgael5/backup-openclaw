# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

## GitHub CI/CD Monitoring (CRITIQUE)

### API Endpoints Obligatoires

```bash
# 1. Lister les runs CI après push
GET /repos/{owner}/{repo}/actions/runs?per_page=5

# 2. Détails d'un run spécifique  
GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs

# 3. Logs d'erreur complets
GET /repos/{owner}/{repo}/actions/runs/{run_id}/logs
```

### Configuration Locale

- **Repo principal:** gaelgael5/my-trainers
- **Timeout polling:** 10 minutes max
- **Interval polling:** 30 secondes
- **Max tentatives:** 3 corrections automatiques
- **Headers requis:** `Accept: application/vnd.github+json`

### Statuts CI à surveiller

- `queued` → En attente
- `in_progress` → En cours (continuer polling)
- `completed` + `conclusion: success` → ✅ MISSION TERMINÉE
- `completed` + `conclusion: failure` → ❌ LIRE LOGS + CORRIGER
