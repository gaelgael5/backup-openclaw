# API CLIENT - Documentation

## Vue d'ensemble

L'API CLIENT de MyTrainer est conçue pour les utilisateurs finaux (clients) qui souhaitent :
- Créer un compte autonome
- Rechercher et découvrir des coachs
- Réserver des séances d'entraînement
- Gérer leur profil et leurs favoris

Cette API est **distincte** de l'API Coach existante et est optimisée pour l'expérience client.

## Architecture

### Authentification

L'API CLIENT utilise un système d'authentification JWT séparé avec :
- **Tokens CLIENT** avec role="client" 
- **Durée de vie** : 1 heure (access) / 7 jours (refresh)
- **Sécurité** : Validation distincte des tokens coach

### Modèles de données

#### EndUser (Client)
```sql
- id (UUID, primary key)
- email (unique, required)
- hashed_password (required)
- first_name, last_name (required)
- phone, date_of_birth (optional)
- avatar_url (optional)
- preferences (JSON - objectifs, niveau, etc.)
- email_verified (boolean)
- is_active (boolean, default: true)
```

#### SportCategory
```sql
- id (UUID)
- name (unique, ex: "Fitness", "Yoga", "Running")
- description, icon_url (optional)
- is_active (boolean)
```

#### CoachSpecialty
```sql
- coach_id, category_id (foreign keys)
- experience_years (optional)
- certification (optional)
- hourly_rate (optional)
```

#### Booking
```sql
- id (UUID)
- client_id, coach_id, category_id (foreign keys)
- session_date (datetime)
- duration_minutes (default: 60)
- hourly_rate, total_price (calculé)
- status (pending, confirmed, cancelled, completed, no_show)
- client_notes, coach_notes (optional)
```

#### ClientFavorite
```sql
- client_id, coach_id (unique constraint)
- created_at (timestamp)
```

## Endpoints disponibles

### 🔐 1. AUTHENTIFICATION CLIENT

#### POST /api/v1/client/register
Inscription d'un nouveau client.

**Request:**
```json
{
  "email": "client@example.com",
  "password": "motdepasse123",
  "first_name": "Jean",
  "last_name": "Dupont",
  "phone": "+33123456789",
  "date_of_birth": "1985-05-15"
}
```

**Response (201):**
```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "token_type": "bearer",
  "expires_in": 3600
}
```

#### POST /api/v1/client/login
Connexion client.

**Request:**
```json
{
  "email": "client@example.com",
  "password": "motdepasse123"
}
```

#### POST /api/v1/client/refresh-token
Renouvellement du token.

**Request:**
```json
{
  "refresh_token": "eyJ..."
}
```

#### POST /api/v1/client/reset-password
Demande de réinitialisation du mot de passe.

#### POST /api/v1/client/reset-password/confirm
Confirmation de la réinitialisation.

### 🔍 2. RECHERCHE DE COACHS

#### GET /api/v1/coaches
Liste des coachs actifs avec filtrage.

**Query Parameters:**
- `category_id` (UUID) - Filtrer par catégorie de sport
- `min_rate`, `max_rate` (float) - Fourchette de tarifs
- `experience_years` (int) - Expérience minimale
- `search_term` (string) - Recherche dans nom/bio
- `limit` (int, default: 20) - Nombre de résultats
- `offset` (int, default: 0) - Pagination

**Response:**
```json
[
  {
    "id": "uuid",
    "first_name": "Coach",
    "last_name": "Fitness",
    "bio": "Entraîneur expérimenté...",
    "avatar_url": "https://...",
    "is_active": true,
    "specialties": [
      {
        "category_id": "uuid",
        "category_name": "Fitness",
        "experience_years": 8,
        "certification": "NASM CPT",
        "hourly_rate": 50.0
      }
    ],
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

#### GET /api/v1/coaches/search
Recherche avancée avec filtres structurés.

#### GET /api/v1/coaches/{coach_id}
Profil détaillé d'un coach.

#### GET /api/v1/coaches/sports/categories
Liste des catégories de sport disponibles.

**Response:**
```json
[
  {
    "id": "uuid",
    "name": "Fitness & Musculation",
    "description": "Entraînement en salle...",
    "icon_url": "https://...",
    "is_active": true,
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### 📅 3. RÉSERVATIONS (BOOKINGS)

#### POST /api/v1/client/bookings
Créer une réservation.

**Headers:** `Authorization: Bearer {access_token}`

**Request:**
```json
{
  "coach_id": "uuid",
  "category_id": "uuid", 
  "session_date": "2024-03-15T14:00:00Z",
  "duration_minutes": 60,
  "client_notes": "Premier cours, objectif remise en forme"
}
```

**Response (201):**
```json
{
  "id": "uuid",
  "client_id": "uuid",
  "coach_id": "uuid",
  "category_id": "uuid",
  "session_date": "2024-03-15T14:00:00Z",
  "duration_minutes": 60,
  "hourly_rate": 50.0,
  "total_price": 50.0,
  "status": "pending",
  "client_notes": "Premier cours...",
  "coach_notes": null,
  "coach_name": "Coach Fitness",
  "category_name": "Fitness",
  "confirmed_at": null,
  "cancelled_at": null,
  "completed_at": null,
  "created_at": "2024-03-01T00:00:00Z",
  "updated_at": "2024-03-01T00:00:00Z"
}
```

#### GET /api/v1/client/bookings
Liste des réservations du client.

**Query Parameters:**
- `status_filter` - Filtrer par statut (pending, confirmed, etc.)
- `from_date`, `to_date` - Filtrer par dates
- `limit`, `offset` - Pagination

#### PUT /api/v1/client/bookings/{booking_id}/cancel
Annuler une réservation.

**Request:**
```json
{
  "cancellation_reason": "Conflit d'horaire"
}
```

#### GET /api/v1/client/bookings/history
Historique complet des réservations.

### 👤 4. PROFIL CLIENT

#### GET /api/v1/client/profile
Profil du client connecté.

**Response:**
```json
{
  "id": "uuid",
  "email": "client@example.com",
  "first_name": "Jean",
  "last_name": "Dupont",
  "phone": "+33123456789",
  "date_of_birth": "1985-05-15",
  "avatar_url": null,
  "preferences": {
    "goals": ["weight_loss", "strength"],
    "level": "intermediate",
    "training_days": 3
  },
  "email_verified": true,
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

#### PUT /api/v1/client/profile
Mise à jour du profil.

**Request:**
```json
{
  "first_name": "Jean-Claude",
  "phone": "+33987654321",
  "preferences": {
    "goals": ["muscle_gain"],
    "level": "advanced"
  }
}
```

### ⭐ 5. FAVORIS

#### GET /api/v1/client/favorites
Liste des coachs favoris.

#### POST /api/v1/client/favorites/{coach_id}
Ajouter un coach aux favoris.

#### DELETE /api/v1/client/favorites/{coach_id}
Retirer un coach des favoris.

#### GET /api/v1/client/favorites/{coach_id}/check
Vérifier si un coach est en favoris.

**Response:**
```json
{
  "is_favorite": true
}
```

## Gestion des erreurs

### Codes d'erreur standard

- **400** - Validation des données / Erreur de logique métier
- **401** - Token manquant, invalide ou expiré
- **403** - Accès interdit
- **404** - Ressource non trouvée
- **409** - Conflit (email déjà utilisé, favoris en double, etc.)
- **422** - Erreur de validation Pydantic
- **500** - Erreur serveur

### Format des réponses d'erreur

```json
{
  "error": true,
  "detail": "Message d'erreur explicite",
  "status_code": 400
}
```

## Sécurité

### Rate Limiting
- **Authentification** : 5 tentatives/minute par IP
- **API générale** : 100 requêtes/minute par utilisateur authentifié
- **Recherche** : 20 requêtes/minute par IP non authentifié

### Validation des données
- **Pydantic** pour la validation des schémas
- **Protection CSRF** activée
- **Headers sécurisés** (CORS configuré)

### Protection des données
- **Mots de passe** : Hachage bcrypt
- **Tokens JWT** : Signed avec clé secrète
- **Données personnelles** : Accès restreint au propriétaire

## Tests

### Lancement des tests
```bash
# Tests complets
pytest tests/test_client_*.py -v

# Tests spécifiques
pytest tests/test_client_auth.py::TestClientAuth::test_register_client_success -v

# Coverage
pytest tests/test_client_*.py --cov=app.api.v1 --cov-report=html
```

### Couverture des tests

- ✅ **Authentification** : 100% (inscription, login, refresh, reset)
- ✅ **Recherche coachs** : 100% (filtres, pagination, catégories)
- ✅ **Réservations** : 100% (création, annulation, historique)
- ✅ **Profil/Favoris** : 100% (CRUD complet)

## Déploiement

### Variables d'environnement

```bash
# Base de données
DATABASE_URL=postgresql+asyncpg://user:pass@host:5432/mycoach

# Sécurité
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256

# App
BASE_URL=https://api.mytrainer.com
DEBUG=false
```

### Initialisation des données

```bash
# Créer les catégories de sport de base
python mycoach/scripts/init_client_data.py
```

### Migration depuis l'ancienne API

L'API CLIENT est **additive** - elle n'impacte pas l'API Coach existante.
Les deux APIs coexistent et partagent certaines tables (Coach, SportCategory).

## Roadmap

### Phase 1 ✅ (Actuelle)
- Authentification CLIENT complète
- Recherche et découverte des coachs
- Système de réservation basique
- Gestion profil et favoris

### Phase 2 (À venir)
- Notifications push (réservation confirmée, rappels)
- Système de notation/avis des coachs
- Chat client-coach intégré
- Paiement en ligne (Stripe)

### Phase 3 (Future)
- Application mobile dédiée
- Géolocalisation des coachs
- Recommandations IA
- Programme d'entraînement personnalisé