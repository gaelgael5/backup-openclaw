# Plan de Migration HTTPS/TLS - MyCoach Production

**Date**: 2026-03-02  
**Responsable**: Sysadmin OpenClaw  
**Objectif**: Sécuriser le transport des données avec HTTPS/TLS

---

## 🎯 **OBJECTIF**

Migrer l'API MyCoach de HTTP vers HTTPS avec certificats SSL/TLS valides, pour garantir :
- **Confidentialité** : Chiffrement des données en transit
- **Intégrité** : Protection contre l'altération des données
- **Authentification** : Vérification de l'identité du serveur
- **Confiance** : Conformité aux standards de sécurité web

---

## 📋 **PRÉREQUIS**

### **Technique**
- [ ] Nom de domaine configuré (ex: `api.mycoach.com`)
- [ ] DNS pointant vers 192.168.10.63
- [ ] Accès root au serveur Proxmox/Docker
- [ ] Port 443 ouvert dans le firewall
- [ ] Nginx comme reverse proxy

### **Organisationnel**
- [ ] Validation métier du nom de domaine
- [ ] Fenêtre de maintenance planifiée
- [ ] Plan de rollback documenté
- [ ] Tests de charge post-migration

---

## 🏗️ **ARCHITECTURE CIBLE**

```
Internet
    ↓ HTTPS:443
[Load Balancer/Cloudflare] (Optionnel)
    ↓ HTTPS:443
[Nginx Reverse Proxy]
    ↓ HTTP:8200 (interne)
[FastAPI Container]
    ↓
[PostgreSQL]
```

**Chiffrement en couches** :
- Transport : TLS 1.3 (externe)
- Application : HTTPS (internal backend)
- Base de données : SSL/TLS connections

---

## ⚡ **PLAN D'IMPLÉMENTATION**

### **Phase 1 : Préparation (J+0 à J+2)**

#### 1.1 Configuration DNS
```bash
# Vérifier/configurer DNS A record
dig api.mycoach.com +short
# Doit retourner l'IP publique (ou load balancer)

# Pour test interne (ajuster /etc/hosts si nécessaire)
echo "192.168.10.63 api.mycoach.com" >> /etc/hosts
```

#### 1.2 Installation Certbot
```bash
# Sur le container Docker/host
apt-get update
apt-get install -y certbot python3-certbot-nginx

# Ou via Docker (recommandé pour prod)
docker run -it --rm \
  -v /opt/mycoach/certs:/etc/letsencrypt \
  -v /var/www/html:/var/www/html \
  certbot/certbot certificates
```

#### 1.3 Configuration Nginx - Base
```nginx
# /opt/mycoach/nginx/conf.d/mycoach.conf
server {
    listen 80;
    server_name api.mycoach.com;
    
    # Temporaire : redirection ACME challenge
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
    
    # Redirection vers HTTPS (à activer après certificat)
    # return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.mycoach.com;
    
    # Certificats SSL (à configurer)
    ssl_certificate /etc/letsencrypt/live/api.mycoach.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.mycoach.com/privkey.pem;
    
    # Configuration SSL moderne
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Headers de sécurité
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-Frame-Options DENY always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Proxy vers FastAPI
    location / {
        proxy_pass http://mycoach-api:8200;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
    }
}
```

### **Phase 2 : Obtention Certificats (J+2 à J+3)**

#### 2.1 Certificat Let's Encrypt
```bash
# Méthode 1 : Standalone (arrêt temporaire nginx)
docker-compose stop nginx
certbot certonly --standalone -d api.mycoach.com --email admin@mycoach.com --agree-tos

# Méthode 2 : Webroot (sans interruption)
certbot certonly --webroot -w /var/www/html -d api.mycoach.com --email admin@mycoach.com --agree-tos

# Méthode 3 : DNS Challenge (pour domaines internes)
certbot certonly --manual --preferred-challenges dns -d api.mycoach.com
```

#### 2.2 Configuration Auto-Renouvellement
```bash
# Cron job pour renouvellement automatique
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -

# Test du renouvellement
certbot renew --dry-run

# Hook post-renewal pour recharger nginx
echo 'systemctl reload nginx' > /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
chmod +x /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
```

### **Phase 3 : Activation HTTPS (J+3 à J+4)**

#### 3.1 Update Docker Compose
```yaml
# docker-compose.yml
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"  # Nouveau port
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./certs:/etc/letsencrypt:ro  # Certificats en lecture seule
      - ./web:/var/www/html
    depends_on:
      - mycoach-api
    restart: unless-stopped

  mycoach-api:
    image: blackbeardteam/mycoach-api:latest
    environment:
      - CORS_ORIGINS=["https://api.mycoach.com"]  # Update CORS
      - SECURE_COOKIES=true  # Forcer HTTPS pour cookies
    # ... reste inchangé
```

#### 3.2 Test de Configuration
```bash
# Vérifier syntaxe nginx
docker exec mycoach_nginx nginx -t

# Test SSL avec OpenSSL
openssl s_client -connect api.mycoach.com:443 -servername api.mycoach.com

# Test grade SSL (optionnel)
curl -s "https://api.ssllabs.com/api/v3/analyze?host=api.mycoach.com" | jq .
```

### **Phase 4 : Migration Progressive (J+4 à J+5)**

#### 4.1 Activation HTTPS-Only
```nginx
# Activer redirection HTTP → HTTPS
server {
    listen 80;
    server_name api.mycoach.com;
    return 301 https://$server_name$request_uri;
}
```

#### 4.2 Test des Applications Clientes
```bash
# Test API endpoints
curl -H "X-API-Key: test-key" https://api.mycoach.com/health
curl -H "X-API-Key: test-key" https://api.mycoach.com/auth/me

# Vérifier HSTS headers
curl -I https://api.mycoach.com/ | grep -i strict
```

---

## 🔒 **CONFIGURATION AVANCÉE**

### **Perfect Forward Secrecy (PFS)**
```nginx
# Configuration SSL optimisée
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
ssl_prefer_server_ciphers off;
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

# Génération DH params
openssl dhparam -out /etc/letsencrypt/ssl-dhparams.pem 2048
```

### **OCSP Stapling**
```nginx
# Améliorer performances SSL
ssl_stapling on;
ssl_stapling_verify on;
ssl_trusted_certificate /etc/letsencrypt/live/api.mycoach.com/chain.pem;
resolver 8.8.8.8 8.8.4.4 valid=300s;
```

### **Content Security Policy (CSP)**
```nginx
# Protection contre XSS
add_header Content-Security-Policy "
    default-src 'self';
    script-src 'self' 'unsafe-inline';
    style-src 'self' 'unsafe-inline';
    img-src 'self' data: https:;
    connect-src 'self' https://api.mycoach.com;
    frame-ancestors 'none';
" always;
```

---

## 📊 **TESTS & VALIDATION**

### **Tests Automatisés**
```bash
#!/bin/bash
# test-https.sh

API_URL="https://api.mycoach.com"

# Test 1: Connectivité HTTPS
echo "Test 1: Connectivité HTTPS"
curl -s -o /dev/null -w "HTTP %{http_code} - Time: %{time_total}s\n" "$API_URL/health"

# Test 2: Headers de sécurité
echo "Test 2: Headers de sécurité"
curl -s -I "$API_URL" | grep -E "(Strict-Transport-Security|X-Content-Type-Options)"

# Test 3: Grade SSL
echo "Test 3: Test SSL"
echo | openssl s_client -connect api.mycoach.com:443 2>/dev/null | openssl x509 -noout -dates

# Test 4: Performance API
echo "Test 4: Performance API"
curl -w "@curl-format.txt" -s -o /dev/null "$API_URL/auth/me"
```

### **Monitoring Post-Migration**
```bash
# Créer dashboard de monitoring
curl -X POST https://api.mycoach.com/admin/monitoring \
  -H "Content-Type: application/json" \
  -d '{
    "metrics": ["ssl_cert_expiry", "https_response_time", "tls_handshake_time"],
    "alerts": {
      "ssl_expiry_days": 30,
      "response_time_ms": 2000
    }
  }'
```

---

## ⚠️ **RISQUES & MITIGATION**

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Expiration certificat | 🔴 Haute | 🟡 Moyen | Monitoring auto + alerts |
| Performance dégradée | 🟡 Moyen | 🟡 Moyen | Tests de charge préalables |
| Apps mobiles incompatibles | 🟠 Élevé | 🔴 Faible | Tests sur différentes versions |
| Problème DNS | 🔴 Haute | 🔴 Faible | Backup DNS + plan rollback |

### **Plan de Rollback**
```bash
# En cas de problème critique
# 1. Désactiver HTTPS temporairement
docker exec nginx sed -i 's/443 ssl/443/' /etc/nginx/conf.d/mycoach.conf
docker exec nginx sed -i 's/return 301/#return 301/' /etc/nginx/conf.d/mycoach.conf
docker exec nginx nginx -s reload

# 2. Ou revenir à la version HTTP
docker-compose down
git checkout previous-version
docker-compose up -d
```

---

## 📅 **PLANNING DÉTAILLÉ**

| Étape | Durée | Responsable | Validation |
|-------|-------|-------------|------------|
| Configuration DNS | 2h | DevOps | `dig` test |
| Installation Certbot | 1h | SysAdmin | `certbot --version` |
| Configuration Nginx | 4h | SysAdmin | `nginx -t` |
| Obtention certificats | 30min | SysAdmin | `openssl x509` check |
| Tests internes | 2h | Dev+Ops | API tests pass |
| Mise en production | 30min | SysAdmin | Monitoring OK |
| Tests clients mobiles | 4h | QA Team | App compatibility |

**Temps total estimé** : 2 jours (14h)  
**Fenêtre de maintenance** : 1h en production

---

## 🔧 **COMMANDES UTILES**

```bash
# Vérification certificat
openssl x509 -in /etc/letsencrypt/live/api.mycoach.com/cert.pem -text -noout

# Test connectivité SSL
nmap --script ssl-enum-ciphers -p 443 api.mycoach.com

# Monitoring en temps réel
watch -n 5 'curl -w "Time: %{time_total}s\n" -s -o /dev/null https://api.mycoach.com/health'

# Logs SSL/TLS
tail -f /var/log/nginx/access.log | grep -E "ssl|tls"
```

---

## ✅ **CHECKLIST POST-MIGRATION**

- [ ] Certificat SSL valide et vérifié
- [ ] Redirection HTTP → HTTPS fonctionnelle  
- [ ] Headers de sécurité configurés
- [ ] HSTS activé et testé
- [ ] Apps mobiles fonctionnelles avec HTTPS
- [ ] Performance acceptable (< 2s response time)
- [ ] Monitoring SSL/TLS en place
- [ ] Documentation mise à jour
- [ ] Équipe formée sur le renouvellement certificats

---

**Next**: Consulter `backup-strategy.md` pour sécuriser les données et `monitoring-setup.md` pour superviser l'infrastructure.