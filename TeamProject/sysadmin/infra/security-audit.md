# Audit de Sécurité MyCoach - Infrastructure & Application

**Date**: 2026-03-02  
**Auditeur**: Sysadmin OpenClaw  
**Scope**: Backend API FastAPI + Infrastructure Proxmox + App Mobile

---

## 🔴 **RISQUES CRITIQUES** (Action immédiate requise)

### 1. **Transport non sécurisé (HTTPS manquant)**
- **Statut**: ❌ HTTPS non configuré sur 192.168.10.63:8200
- **Impact**: Données sensibles (mots de passe, clés API, données de santé) transmises en plain text
- **Données à risque**: 
  - Clés API d'authentification
  - Profils utilisateurs
  - Données de paiements  
  - Données de santé (performances sportives)
- **Action**: Migration HTTPS obligatoire AVANT mise en production publique

### 2. **Exposition d'API sensibles sans contrôle**
- **Statut**: ❌ API accessible sans rate limiting visible
- **Endpoints exposés**:
  - `/auth/register` - Inscription sans captcha
  - `/auth/login` - Authentification sans protection brute force
  - `/admin/*` - Endpoints d'administration 
- **Risque**: Attaques par force brute, création de comptes en masse
- **Action**: Mise en place de rate limiting immédiate

### 3. **Gestion des secrets et clés de chiffrement**
- **Observation**: Variables d'environnement critiques identifiées
  - `FIELD_ENCRYPTION_KEY` - Chiffrement des données sensibles
  - `TOKEN_ENCRYPTION_KEY` - Chiffrement des tokens
- **Risque**: Si compromises, déchiffrement de toutes les données utilisateurs
- **Action**: Audit de la gestion des secrets + rotation des clés

---

## 🟠 **RISQUES ÉLEVÉS** (Correction prioritaire)

### 4. **Headers de sécurité incomplets**
- **Configuré**: ✅ `X-Content-Type-Options`, `X-Frame-Options`, `X-XSS-Protection`  
- **Manquant**: ❌ `Strict-Transport-Security` (HSTS), `Content-Security-Policy`
- **Impact**: Vulnérabilités XSS, clickjacking avancé
- **Recommandation**: Compléter les headers de sécurité

### 5. **Endpoints d'administration exposés**
- **Observation**: Routes `/admin/*` présentes dans l'API
  - `/admin/machines/pending` - Gestion machines
  - `/admin/blocked-domains` - Gestion domaines
  - `/admin/feedback` - Gestion feedbacks
- **Risque**: Accès non autorisé aux fonctions d'administration
- **Action**: Vérification des contrôles d'accès admin

### 6. **Données RGPD sensibles**
- **Fonctions identifiées**:
  - Export complet utilisateur (`/users/me/export`)
  - Suppression de compte (`/users/me/`)  
  - Gestion des consentements
- **Conformité**: Mécanismes RGPD présents ✅
- **Risque**: Fuite de données lors des exports
- **Action**: Audit des permissions d'export

---

## 🟡 **RISQUES MODÉRÉS** (Amélioration continue)

### 7. **Intégrations tierces**
- **Services connectés**: Strava, Google Calendar, Balances connectées
- **Tokens OAuth**: Stockage et expiration à vérifier
- **Recommandation**: Audit des scopes OAuth et révocation automatique

### 8. **Gestion des uploads/fichiers**
- **Endpoints d'upload**: Certification documents, avatars
- **Risques**: Upload de fichiers malveillants
- **Recommandation**: Validation stricte des types de fichiers

### 9. **Base de données**
- **Type**: PostgreSQL (bonne pratique ✅)
- **Chiffrement**: À vérifier (encryption at rest)
- **Backups**: Stratégie à documenter
- **Action**: Audit des permissions DB + chiffrement

---

## 📊 **ANALYSE PAR CATÉGORIE**

### **Authentication & Authorization**
| Élément | Statut | Commentaire |
|---------|--------|-------------|
| Authentification multi-facteurs | ❌ | Seulement email + SMS OTP |
| Rotation des clés API | ❓ | À vérifier |
| Session timeout | ❓ | À vérifier |
| Gestion des rôles | ✅ | Coach/Client/Admin |

### **Données Sensibles**
| Type de donnée | Protection | Conformité |
|----------------|------------|------------|
| Mots de passe | ✅ | Hachage (à vérifier algo) |
| Données de santé | ❓ | Chiffrement à vérifier |
| Données de paiement | ❓ | PCI-DSS à évaluer |
| Données personnelles | ✅ | RGPD compliance |

### **Infrastructure**
| Composant | Sécurité | Recommandation |
|-----------|----------|----------------|
| Reverse proxy | ✅ Nginx | Compléter config SSL |
| Conteneurs Docker | ❓ | Scanner les vulnérabilités |
| Host Proxmox | ❓ | Audit accès root |
| Réseau interne | ✅ | Segmentation OK |

---

## ⚡ **PLAN D'ACTION PRIORITAIRE**

### **Phase 1 - Critique (J+0 à J+7)**
1. ❗ **Configurer HTTPS/TLS** avec certificats Let's Encrypt
2. ❗ **Implémenter rate limiting** sur endpoints sensibles  
3. ❗ **Audit des clés de chiffrement** et rotation si nécessaire
4. ❗ **Restreindre accès admin** (IP whitelisting + 2FA)

### **Phase 2 - Élevé (J+7 à J+14)**  
1. 🔸 **Compléter headers de sécurité** (HSTS, CSP)
2. 🔸 **Scanner vulnérabilités** images Docker
3. 🔸 **Audit permissions base de données**
4. 🔸 **Test de pénétration** endpoints sensibles

### **Phase 3 - Modéré (J+14 à J+30)**
1. 🔹 **Monitoring de sécurité** (logs, alertes)
2. 🔹 **Audit intégrations OAuth** tierces  
3. 🔹 **Documentation procédures** incident response
4. 🔹 **Formation équipe** bonnes pratiques sécurité

---

## 🛡️ **RECOMMANDATIONS TECHNIQUES**

### **Configuration Nginx recommandée**
```nginx
# HTTPS obligatoire
listen 443 ssl http2;
ssl_certificate /path/to/cert.pem;
ssl_certificate_key /path/to/key.pem;

# Headers de sécurité
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header Content-Security-Policy "default-src 'self'" always;
add_header X-Content-Type-Options nosniff always;
add_header X-Frame-Options DENY always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;

# Rate limiting
limit_req_zone $binary_remote_addr zone=auth:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=api:10m rate=100r/m;
```

### **Variables d'environnement sécurisées**
```bash
# Utiliser des secrets Kubernetes ou HashiCorp Vault
FIELD_ENCRYPTION_KEY={{ secret "mycoach/encryption/field" }}
TOKEN_ENCRYPTION_KEY={{ secret "mycoach/encryption/token" }}
DATABASE_URL={{ secret "mycoach/database/url" }}

# Pas de clés en dur dans .env
```

---

## 📋 **CHECKLIST PRODUCTION**

- [ ] HTTPS configuré et testé
- [ ] Rate limiting activé  
- [ ] Headers de sécurité complets
- [ ] Accès admin restreints
- [ ] Monitoring/alertes actifs
- [ ] Procédure incident response documentée
- [ ] Backups testés et chiffrés
- [ ] Logs de sécurité centralisés

---

**Prochaine étape**: Consulter les documents `https-setup.md`, `backup-strategy.md` et `monitoring-setup.md` pour les plans détaillés d'implémentation.