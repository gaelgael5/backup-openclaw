# Rapport de Déploiement MyCoach Backend

**Date:** 2026-03-03 09:45 GMT+1  
**Machine cible:** 192.168.10.63  
**Image déployée:** ghcr.io/gaelgael5/my-trainers/backend:latest  
**Statut:** ✅ DÉPLOIEMENT RÉUSSI

## Résumé

Le container MyCoach backend a été déployé avec succès sur la machine de test distante. L'API répond correctement sur le port 8000 et tous les health checks passent.

## Actions réalisées

### 1. Connexion SSH sécurisée
```bash
sshpass -p 'g&L8NT#ybR&9Mi8P' ssh -o StrictHostKeyChecking=no root@192.168.10.63
```

### 2. Pull de l'image Docker
```bash
docker pull ghcr.io/gaelgael5/my-trainers/backend:latest
```
**Résultat:** Image téléchargée avec le digest `sha256:5a0b2870bae10ac1bd2cd14b4baa74668f893aeb9a2b52086547079790c2bf34`

### 3. Arrêt container existant
```bash
docker stop mycoach-api
docker rm mycoach-api
```

### 4. Résolution conflit port 8000
**Problème détecté:** Portainer utilisait le port 8000
```bash
docker stop portainer
```

### 5. Démarrage nouveau container
```bash
docker run -d \
  --name mycoach-api \
  --network mycoach_mycoach-internal \
  -p 8000:8000 \
  --restart unless-stopped \
  --health-cmd='curl -f http://localhost:8000/health || exit 1' \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  ghcr.io/gaelgael5/my-trainers/backend:latest
```

## Vérifications effectuées

### ✅ Container Status
```
NAMES         STATUS                    PORTS
mycoach-api   Up 42 seconds (healthy)   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp
```

### ✅ Health Check API
```bash
curl http://192.168.10.63:8000/health
# Réponse: {"status":"healthy"} - HTTP 200 OK
# Temps de réponse: 0.002420s
```

### ✅ Logs Application
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
INFO:     127.0.0.1:41182 - "GET /health HTTP/1.1" 200 OK
```

## Configuration déployée

- **Container Name:** mycoach-api
- **Network:** mycoach_mycoach-internal 
- **Port mapping:** 0.0.0.0:8000->8000/tcp
- **Restart policy:** unless-stopped
- **Health checks:** Activés (intervalle 30s)
- **Image:** ghcr.io/gaelgael5/my-trainers/backend:latest

## État final

🟢 **MyCoach Backend est opérationnel sur 192.168.10.63:8000**

- Container: healthy
- API accessible: ✅
- Health endpoint: ✅ 200 OK
- Logs: ✅ Application démarrée

## Notes importantes

- **Portainer temporairement arrêté** pour libérer le port 8000
- Container configuré avec redémarrage automatique
- Health checks configurés pour surveillance continue
- Réseau Docker: mycoach_mycoach-internal

## Accès

**URL API:** http://192.168.10.63:8000  
**Health Check:** http://192.168.10.63:8000/health

Le déploiement est prêt pour les tests immédiats.