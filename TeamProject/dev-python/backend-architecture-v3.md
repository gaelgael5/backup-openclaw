# Architecture Backend V3 — MyCoach

## 🚀 Vue d'ensemble

L'architecture V3 doit supporter **8 locales**, **intégrations OAuth2 multiples**, **paiements Stripe Connect**, et **60+ écrans fonctionnels** avec une complexité technique exponentiellement supérieure au MVP.

---

## 🏗️ Architecture proposée

### Core Services Architecture

```
┌─────────────────────────────────────────────────┐
│               API Gateway (FastAPI)             │
│         • Rate limiting par locale/user         │
│         • Request logging & monitoring          │
│         • CORS multi-domaines                   │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────┼───────────────────────────────┐
│            Service Layer                        │
├─────────────────────────────────────────────────┤
│ AuthService     │ I18nService    │ PaymentService│
│ • JWT + OAuth2  │ • 8 locales    │ • Stripe Connect│
│ • Multi-provider│ • Currency     │ • Multi-currency│
│                 │ • Formatting   │ • Webhooks     │
├─────────────────┼────────────────┼───────────────┤
│ BookingService  │ NotifService   │ IntegrationSvc│
│ • Multi-timezone│ • Push notifs  │ • Strava API   │
│ • Availability  │ • Email/SMS    │ • Garmin API   │
│ • Conflicts     │ • i18n templates│ • Withings API │
└─────────────────┴────────────────┴───────────────┘
                  │
┌─────────────────┼───────────────────────────────┐
│              Data Layer                         │
├─────────────────────────────────────────────────┤
│ PostgreSQL      │ Redis Cache    │ File Storage  │
│ • Partitioning  │ • Sessions     │ • S3/MinIO    │
│ • Read replicas │ • Rate limits  │ • CDN         │
│ • Full-text     │ • Cache i18n   │ • Multi-region│
│ search          │ translations   │               │
└─────────────────────────────────────────────────┘
```

---

## 🔧 Services détaillés

### 1. Authentication & Authorization Service

**Responsabilités :**
- JWT token management + refresh logic
- OAuth2 intégration multi-providers (Strava, Garmin, Withings, etc.)
- Role-based access control (Coach/Client)
- Multi-tenant organization par pays/locale

**Endpoints clés :**
```python
# OAuth2 flows
POST /auth/oauth/{provider}/authorize
POST /auth/oauth/{provider}/callback
POST /auth/oauth/{provider}/refresh

# Traditional auth
POST /auth/login
POST /auth/register
POST /auth/refresh
GET /auth/me

# Account linking
POST /auth/link/{provider}
DELETE /auth/unlink/{provider}
```

**Modèle de données étendu :**
```python
class User(BaseModel):
    id: UUID
    email: str
    role: UserRole  # Coach, Client
    locale: LocaleCode  # fr-FR, en-US, etc.
    timezone: str
    connected_accounts: List[ConnectedAccount]
    created_at: datetime
    
class ConnectedAccount(BaseModel):
    provider: OAuthProvider  # Strava, Garmin, etc.
    external_id: str
    access_token: str  # encrypted
    refresh_token: str  # encrypted
    scopes: List[str]
    expires_at: datetime
```

### 2. Internationalisation (I18n) Service

**Responsabilités :**
- Gestion 8 locales complètes
- Formatage devises, dates, unités
- Localisation des templates email/SMS
- API responses localisées

**Architecture i18n :**
```python
class I18nService:
    # Cache Redis des traductions par locale
    def get_translation(locale: str, key: str) -> str
    def format_currency(amount: Decimal, locale: str) -> str
    def format_date(date: datetime, locale: str) -> str
    def format_weight(weight: float, locale: str) -> str  # kg/lb
    
# Middleware automatique
class LocaleMiddleware:
    # Détection locale : Accept-Language > user profile > fallback
    def extract_locale(request: Request) -> LocaleCode
```

**Stockage traductions :**
```json
// Redis: translations:fr-FR:coach.profile.title
{
  "fr-FR": {
    "coach.profile.title": "Mon profil coach",
    "currency.format": "€{amount}",
    "weight.unit": "kg"
  },
  "en-US": {
    "coach.profile.title": "My coach profile", 
    "currency.format": "${amount}",
    "weight.unit": "lb"
  }
}
```

### 3. Payment Service (Stripe Connect)

**Responsabilités :**
- Onboarding coachs sur Stripe Connect
- Gestion multi-devises (EUR, USD, GBP, CHF, BRL)
- Split payments (commission plateforme)
- Webhooks Stripe + réconciliation

**Architecture paiements :**
```python
class PaymentService:
    # Stripe Connect onboarding
    async def create_connect_account(coach_id: UUID, country: str)
    async def complete_onboarding(coach_id: UUID, return_url: str)
    
    # Payment processing
    async def create_payment_intent(
        booking_id: UUID, 
        amount: Decimal, 
        currency: CurrencyCode,
        application_fee: Decimal  # Commission
    )
    
    # Webhooks handling
    async def handle_webhook(event: StripeEvent)
```

**Modèle financier :**
```python
class CoachStripeAccount(BaseModel):
    coach_id: UUID
    stripe_account_id: str
    onboarding_status: OnboardingStatus
    country: CountryCode
    default_currency: CurrencyCode
    
class Payment(BaseModel):
    id: UUID
    booking_id: UUID
    amount: Decimal
    currency: CurrencyCode
    stripe_payment_intent_id: str
    application_fee: Decimal  # Commission plateforme
    status: PaymentStatus
    metadata: Dict[str, Any]
```

### 4. Integration Service (APIs tierces)

**Responsabilités :**
- Synchronisation données fitness (Strava, Garmin, Withings)
- Rate limiting par provider
- Data mapping vers modèle unifié
- Webhook handling des providers

**Providers supportés :**
```python
class HealthDataProvider(Enum):
    STRAVA = "strava"
    GARMIN = "garmin_connect"
    WITHINGS = "withings"
    FITBIT = "fitbit"  # Future
    APPLE_HEALTH = "apple_health"  # Future
    
class IntegrationService:
    async def sync_user_data(user_id: UUID, provider: HealthDataProvider)
    async def get_activities(user_id: UUID, date_range: DateRange)
    async def get_health_metrics(user_id: UUID, metric_types: List[str])
```

**Modèle unifié :**
```python
class Activity(BaseModel):
    id: UUID
    user_id: UUID
    external_id: str
    provider: HealthDataProvider
    activity_type: ActivityType  # Running, Cycling, etc.
    start_time: datetime
    duration_seconds: int
    distance_meters: Optional[float]
    calories: Optional[int]
    raw_data: Dict[str, Any]  # Provider-specific
```

### 5. Notification Service

**Responsabilités :**
- Push notifications multiplateforme
- Email/SMS avec templates i18n
- Préférences utilisateur par canal
- Scheduling & retry logic

```python
class NotificationService:
    async def send_push(
        user_id: UUID, 
        message: str, 
        data: Dict[str, Any],
        locale: LocaleCode
    )
    
    async def send_email_template(
        user_id: UUID,
        template_name: str,
        variables: Dict[str, Any],
        locale: LocaleCode
    )
```

---

## 🗄️ Base de données

### Schema principal (PostgreSQL)

**Partitioning strategy :**
- `users` table partitioned by `locale` (optimisation géographique)
- `bookings` partitioned by `created_at` (range monthly)
- `activities` partitioned by `user_id` hash (distribution load)

**Index strategy :**
```sql
-- Recherche multi-locale optimisée
CREATE INDEX idx_coaches_search 
ON coaches USING gin(to_tsvector('french', name || ' ' || specialties));

-- Geospatial pour gym chains
CREATE INDEX idx_gyms_location 
ON gyms USING gist(location);

-- Performance bookings
CREATE INDEX idx_bookings_availability 
ON bookings (coach_id, start_time, status) 
WHERE status IN ('confirmed', 'pending');
```

### Cache Layer (Redis)

**Patterns de cache :**
```python
# Cache traductions (TTL: 24h)
"translations:{locale}:{key}" -> str

# Cache disponibilités coach (TTL: 1h) 
"availability:{coach_id}:{date}" -> List[TimeSlot]

# Rate limiting OAuth APIs (TTL: 1h)
"rate_limit:strava:{user_id}" -> int

# Session data (TTL: 30d)
"session:{token}" -> UserSession
```

---

## 🔒 Sécurité

### OAuth2 Security
- PKCE pour tous les flows OAuth2
- State parameter anti-CSRF
- Tokens chiffrés en base (AES-256)
- Refresh token rotation

### API Security  
- Rate limiting adaptatif par endpoint
- Request validation avec Pydantic
- SQL injection protection (SQLAlchemy ORM)
- Input sanitization

### Data Protection
- GDPR compliance (droit à l'oubli)
- Données sensibles chiffrées (PII)
- Audit logs pour accès données
- Backup encryption

---

## 🚀 Scalabilité

### Horizontal Scaling
- API stateless (JWT + Redis sessions)
- Database read replicas par région
- CDN pour assets statiques
- Auto-scaling containers (K8s)

### Performance Targets
- API response time: <200ms P95
- OAuth callback: <1s end-to-end  
- Data sync: <30s pour 1 mois d'activités
- Concurrent users: 10K+ simultanés

---

## 📊 Monitoring & Observabilité

### Métriques techniques
- Latency percentiles par endpoint
- Error rates par provider OAuth
- Cache hit rates Redis
- Database connection pool usage

### Métriques business
- OAuth conversion rates par provider
- Payment success rates par devise
- i18n usage par locale
- Feature adoption par région

---

## 🔄 Migration path MVP → V3

### Phase 1: Infrastructure (2-3 semaines)
1. Setup multi-locale database schema
2. Implement I18n service + middleware
3. Configure Redis cache layer
4. Setup monitoring stack

### Phase 2: Auth & Integrations (3-4 semaines)  
1. OAuth2 providers integration
2. Stripe Connect implementation
3. Health data sync services
4. Notification system

### Phase 3: Features & Polish (4-5 semaines)
1. 60+ screens backend support
2. Advanced booking logic
3. Performance optimizations
4. Security audit & compliance

**TOTAL ESTIMATION: 9-12 semaines backend**

---

Ce document constitue la base architecturale pour supporter les spécifications V3 complètes. L'approche modulaire permet une implémentation progressive tout en maintenant la scalabilité nécessaire.