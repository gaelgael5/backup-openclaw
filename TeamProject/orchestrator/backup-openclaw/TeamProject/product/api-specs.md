# API Spécifications MyCoach MVP - Product Manager

## 📋 Contrat API Flutter ↔ Python Backend

> **Version :** v1.0 MVP  
> **Date :** 02 Mars 2026  
> **Status :** 🔄 DRAFT - À valider par dev-python + dev-flutter

---

## 🎯 Endpoints prioritaires MVP (P0)

### 🔐 Authentification

#### POST `/auth/register` - Inscription
```yaml
# Flutter → Backend
{
  "email": "coach@example.com",
  "password": "securepass",
  "first_name": "Jean",
  "last_name": "Martin",
  "role": "coach|client",
  "phone": "+33612345678"
}

# Backend → Flutter
Success 201:
{
  "message": "Registration successful. Check email for verification.",
  "user_id": "uuid-v4"
}

Error 400:
{
  "error": "email_already_exists",
  "message": "Un compte existe déjà avec cet email"
}
```

**Critères produit :**
- ✅ Validation email obligatoire avant utilisation
- ✅ Password min 8 caractères
- ✅ Role coach/client determines UI flow
- ⚠️ **POINT BLOQUANT** : Séquence après inscription ? Redirect automatique ou manuel ?

#### POST `/auth/login` - Connexion
```yaml
# Flutter → Backend
{
  "email": "coach@example.com",
  "password": "securepass"
}

# Backend → Flutter
Success 200:
{
  "access_token": "jwt-token-here",
  "token_type": "bearer",
  "expires_in": 3600,
  "user": {
    "id": "uuid",
    "role": "coach",
    "email": "coach@example.com",
    "first_name": "Jean",
    "profile_complete": 45
  }
}

Error 401:
{
  "error": "invalid_credentials",
  "message": "Email ou mot de passe incorrect"
}
```

**Critères produit :**
- ✅ JWT token valid 1h, refresh automatique Flutter
- ✅ `profile_complete` % guide onboarding UX
- ✅ Role determines app navigation (coach vs client views)

---

### 👤 Profils Coach

#### GET `/coaches/me` - Mon profil coach
```yaml
# Headers: Authorization: Bearer {jwt_token}

# Backend → Flutter
{
  "id": "uuid",
  "first_name": "Jean",
  "last_name": "Martin",
  "bio": "Coach certifié avec 5 ans d'expérience...",
  "country": "FR",
  "default_currency": "EUR",
  "default_session_duration": 60,
  "specialties": ["musculation", "fitness", "nutrition"],
  "certifications": [
    {
      "id": "cert-uuid",
      "name": "BPJEPS",
      "issuing_org": "Ministère des Sports",
      "document_url": "/uploads/cert-bpjeps.pdf"
    }
  ],
  "rates": [
    {
      "type": "single_session",
      "duration": 60,
      "price": 50.00,
      "currency": "EUR"
    },
    {
      "type": "discovery",
      "duration": 30,
      "price": 25.00,
      "currency": "EUR"
    }
  ],
  "cancellation_policy": "24h",
  "profile_complete": 85
}
```

**Critères produit :**
- ✅ `profile_complete` % basé sur : bio, spécialités, certifs, tarifs, policy
- ✅ Tarifs multiples : single session (obligatoire) + discovery (optionnel)
- ⚠️ **POINT BLOQUANT** : Validation des spécialités = liste fixe ou libre ?

#### PUT `/coaches/me` - Modifier mon profil
```yaml
# Même structure que GET, fields optionnels
# Recalcul automatique profile_complete %
```

---

### 🔍 Recherche Coachs (Client)

#### GET `/coaches` - Liste publique des coachs
```yaml
# Query params: ?country=FR&page=1&limit=20&specialty=musculation

# Backend → Flutter
{
  "coaches": [
    {
      "id": "coach-uuid",
      "first_name": "Jean",
      "last_name": "M.", # Nom masqué pour privacy
      "bio": "Coach certifié...",
      "country": "FR",
      "specialties": ["musculation", "fitness"],
      "min_rate": 25.00,
      "max_rate": 50.00,
      "currency": "EUR",
      "profile_image_url": "/uploads/coach-photo.jpg"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 156,
    "has_next": true
  }
}
```

**Critères produit :**
- ✅ Pagination 20 résultats max par page
- ✅ Filtrage par pays obligatoire (éviter spam international)
- ✅ Privacy : nom de famille masqué en liste publique

---

### 📅 Gestion Booking

#### POST `/bookings` - Demande de réservation
```yaml
# Flutter client → Backend
{
  "coach_id": "coach-uuid",
  "requested_date": "2026-03-05",
  "requested_start_time": "09:00",
  "duration_minutes": 60,
  "rate_type": "single_session",
  "client_message": "Première séance, objectif prise de masse"
}

# Backend → Flutter
Success 201:
{
  "booking_id": "booking-uuid",
  "status": "pending",
  "estimated_price": 50.00,
  "currency": "EUR",
  "message": "Demande envoyée. Le coach confirmera sous 24h."
}

Error 409:
{
  "error": "slot_unavailable",
  "message": "Ce créneau n'est plus disponible"
}
```

#### GET `/bookings` - Mes réservations
```yaml
# Query params: ?status=pending&role=coach&page=1

# Backend → Flutter
{
  "bookings": [
    {
      "id": "booking-uuid",
      "status": "pending|confirmed|cancelled|completed|no_show",
      "client_name": "Marie Durand", # Visible only if coach
      "coach_name": "Jean Martin",   # Visible only if client
      "date": "2026-03-05",
      "start_time": "09:00",
      "duration_minutes": 60,
      "price": 50.00,
      "currency": "EUR",
      "client_message": "Objectif prise de masse",
      "coach_response": null,
      "created_at": "2026-03-02T14:30:00Z"
    }
  ]
}
```

#### PUT `/bookings/{id}/status` - Coach confirmation
```yaml
# Flutter coach → Backend
{
  "status": "confirmed|cancelled",
  "coach_message": "Confirmé ! RDV salle Fitness Park République"
}

# Backend → Flutter
{
  "booking_id": "uuid",
  "new_status": "confirmed",
  "message": "Réservation confirmée"
}
```

**Critères produit :**
- ✅ Booking reste "pending" max 24h puis auto-expire
- ✅ Coach peut cancel avec message obligatoire
- ⚠️ **POINT BLOQUANT** : Gestion créneaux disponibles = algo côté backend ou flutter ?

---

### 👥 Gestion Clients (Coach)

#### GET `/clients` - Liste mes clients
```yaml
# Headers: Authorization: Bearer {jwt_token}

# Backend → Flutter
{
  "clients": [
    {
      "id": "client-uuid",
      "first_name": "Marie",
      "last_name": "Durand",
      "email": "marie@example.com",
      "phone": "+33612345678",
      "relationship_status": "active|inactive|pending",
      "total_sessions": 12,
      "last_session_date": "2026-02-28",
      "total_paid": 600.00,
      "outstanding_balance": 50.00,
      "profile_image_url": "/uploads/client-photo.jpg"
    }
  ],
  "summary": {
    "active_clients": 8,
    "total_outstanding": 150.00,
    "currency": "EUR"
  }
}
```

**Critères produit :**
- ✅ `relationship_status` auto-calculé : active si session < 30 jours
- ✅ `outstanding_balance` = facturé - payé par client

---

### 💰 Paiements Manuels

#### POST `/payments` - Enregistrer paiement reçu
```yaml
# Flutter coach → Backend
{
  "client_id": "client-uuid",
  "amount": 100.00,
  "currency": "EUR",
  "payment_method": "cash|card|bank_transfer|paypal",
  "reference": "TXN-123456", # Optionnel
  "notes": "Paiement 2 séances", # Optionnel
  "payment_date": "2026-03-02"
}

# Backend → Flutter
{
  "payment_id": "payment-uuid",
  "new_balance": 0.00, # Nouveau solde client
  "message": "Paiement enregistré"
}
```

**Critères produit :**
- ✅ Recalcul auto balance client après paiement
- ✅ Historique paiements accessible depuis fiche client
- ✅ Références optionnelles pour traçabilité

---

## 🚨 Points bloquants dev identifiés

### 🔴 CRITIQUES (bloquent MVP)

1. **Gestion créneaux disponibilités**
   - Coach définit-il ses dispos via API ou Flutter local ?
   - Algorithme calcul slots libres = côté backend pour éviter conflits ?
   - Format récurrence : cron-like ou events simples ?

2. **Flow onboarding complet**
   - Séquence après inscription : profile → availability → rates ?
   - Profile completion % = mandatory gate ou suggestion UX ?
   - Redirect auto vers onboarding ou choice utilisateur ?

3. **Validation contraintes business**
   - Min/max durée séance ? (actuellement 15-480min)
   - Min/max tarifs ? Validation côté backend ?
   - Délai annulation par défaut ? (24h hardcodé ?)

### 🟡 IMPORTANTES (impactent UX)

4. **Gestion fuseaux horaires**
   - Stockage UTC backend + display timezone client/coach ?
   - Format date/time API : ISO8601 avec timezone ?

5. **Upload fichiers (photos, certifs)**
   - Endpoint `/upload` + validation MIME types ?
   - Compression images côté Flutter ou backend ?
   - CDN pour servir les assets ?

6. **Messages d'erreur standardisés**
   - Format uniforme pour toutes les 4xx/5xx ?
   - Codes erreur business (email_exists, slot_taken, etc.) ?
   - i18n error messages ou frontend translate ?

---

## ✅ Actions dev-python

1. **Valider endpoints Auth** - Implémenter register + login + JWT
2. **Créer slots availability** - Définir logique créneaux dispos
3. **Finaliser booking flow** - Status transitions + auto-expire
4. **Implémenter client relationships** - Balance calculation + status auto
5. **Setup upload endpoint** - Images profiles + certifs

## ✅ Actions dev-flutter

1. **Implémenter screens Auth** - Register/login avec validation
2. **Créer onboarding coach** - Progressive profile completion
3. **Builder search UI** - Liste coachs + filtres + pagination
4. **Développer booking flow** - Calendar picker + confirmation
5. **Construire client management** - Liste + fiche détail + payments

---

## 📞 Coordination prochaines étapes

**SYNC DEV REQUIS** dans 24h :
- Clarification créneaux disponibilités (architecture backend vs flutter)
- Validation flow onboarding exact
- Agreement format dates/timezone

**LIVRABLES TECHNIQUES** :
- dev-python : Endpoints Auth + Booking + Documentation Swagger
- dev-flutter : Screens Auth + Coach onboarding + Search coachs

**TESTS INTÉGRATION** :
- Register coach → Login → Complete profile → Search par client → Book session