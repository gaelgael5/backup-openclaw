# Data Model Gap Analysis — MVP vs V3

## 🎯 Vue d'ensemble de l'écart

**CONSTAT :** L'écart entre notre MVP et les specs V3 est **massif**. Le MVP couvre ~15% des fonctionnalités V3 en termes de complexité du modèle de données.

| Aspect | MVP Actuel | Specs V3 | Multiplication |
|--------|------------|----------|----------------|
| Tables principales | ~8 tables | ~25-30 tables | **3-4x** |
| Locales supportées | 1 (fr-FR) | 8 locales complètes | **8x** |
| Intégrations externes | 0 | 6+ providers OAuth2 | **∞** |
| Devises | 1 (EUR) | 5 devises + conversion | **5x** |
| Complexité relations | Simple | Complexe (multi-tenant) | **~10x** |

---

## 📊 Modèle de données MVP actuel

### Tables existantes (MVP)
```sql
-- Auth basique
users (id, email, password_hash, role, created_at)
coach_profiles (user_id, name, specialties, hourly_rate, bio)
client_profiles (user_id, name, fitness_goals)

-- Business core
bookings (id, coach_id, client_id, start_time, duration, status, amount)
payments (id, booking_id, amount, payment_method, created_at)

-- Simple metadata
specialties (id, name)
```

**Points forts MVP :**
- ✅ Modèle simple et fonctionnel
- ✅ Relations claires coach/client/booking
- ✅ Auth JWT basique opérationnelle

**Limites critiques :**
- ❌ Aucune internationalisation
- ❌ Pas de multi-devises  
- ❌ Pas d'intégrations externes
- ❌ Pas de système de notifications
- ❌ Pas de gestion de fichiers
- ❌ Pas de multi-tenancy géographique

---

## 🚀 Modèle de données V3 requis

### 1. Système d'internationalisation

**NOUVEAUX BESOINS :**
```sql
-- Gestion multi-locale
CREATE TABLE locales (
    code VARCHAR(5) PRIMARY KEY,  -- fr-FR, en-US, etc.
    name VARCHAR(100),
    currency_code VARCHAR(3),     -- EUR, USD, GBP
    weight_unit VARCHAR(10),      -- kg, lb
    date_format VARCHAR(20),      -- DD/MM/YYYY, MM/DD/YYYY
    enabled BOOLEAN DEFAULT true
);

-- Traductions dynamiques
CREATE TABLE translations (
    id UUID PRIMARY KEY,
    locale_code VARCHAR(5) REFERENCES locales(code),
    translation_key VARCHAR(200),
    translation_value TEXT,
    context VARCHAR(100),         -- coach, client, email, etc.
    UNIQUE(locale_code, translation_key, context)
);

-- User locale preferences
ALTER TABLE users ADD COLUMN locale_code VARCHAR(5) DEFAULT 'fr-FR';
ALTER TABLE users ADD COLUMN timezone VARCHAR(50) DEFAULT 'Europe/Paris';
```

**IMPACT :** 
- Toutes les tables avec contenu textuel doivent supporter i18n
- Les montants doivent être stockés avec leur devise
- Validation des formats par locale requise

### 2. Système OAuth2 & intégrations

**NOUVEAUX BESOINS :**
```sql
-- Connected accounts (Strava, Garmin, etc.)
CREATE TABLE connected_accounts (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    provider VARCHAR(50),         -- strava, garmin, withings
    external_id VARCHAR(100),
    access_token TEXT,            -- ENCRYPTED
    refresh_token TEXT,           -- ENCRYPTED  
    token_expires_at TIMESTAMP,
    scopes TEXT[],
    connection_status VARCHAR(20), -- active, expired, revoked
    last_sync_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Health data synchronized
CREATE TABLE activities (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    external_id VARCHAR(100),
    provider VARCHAR(50),
    activity_type VARCHAR(50),    -- running, cycling, etc.
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    duration_seconds INTEGER,
    distance_meters FLOAT,
    calories_burned INTEGER,
    avg_heart_rate INTEGER,
    raw_data JSONB,              -- Provider-specific data
    created_at TIMESTAMP DEFAULT NOW()
);

-- Health metrics (weight, body fat, etc.)
CREATE TABLE health_metrics (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    metric_type VARCHAR(50),     -- weight, body_fat, etc.
    value DECIMAL(10,2),
    unit VARCHAR(10),
    measured_at TIMESTAMP,
    provider VARCHAR(50),
    raw_data JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**IMPACT :**
- Système de synchronisation périodique requis
- Gestion des tokens expirés + refresh automatique
- Rate limiting par provider
- Conflict resolution données multiples sources

### 3. Système de paiements Stripe Connect

**NOUVEAUX BESOINS :**
```sql
-- Comptes Stripe Connect des coachs
CREATE TABLE coach_stripe_accounts (
    id UUID PRIMARY KEY,
    coach_id UUID REFERENCES users(id),
    stripe_account_id VARCHAR(100) UNIQUE,
    account_status VARCHAR(30),   -- pending, active, restricted
    onboarding_completed BOOLEAN DEFAULT false,
    country_code VARCHAR(2),
    default_currency VARCHAR(3),
    capabilities JSONB,          -- Stripe capabilities
    requirements JSONB,          -- Missing requirements
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Multi-currency pricing
CREATE TABLE coach_pricing (
    id UUID PRIMARY KEY,
    coach_id UUID REFERENCES users(id),
    currency_code VARCHAR(3),
    hourly_rate DECIMAL(10,2),
    session_types JSONB,         -- Différents types de séances
    cancellation_policy JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Enhanced payments avec Stripe
ALTER TABLE payments ADD COLUMN stripe_payment_intent_id VARCHAR(100);
ALTER TABLE payments ADD COLUMN currency_code VARCHAR(3);
ALTER TABLE payments ADD COLUMN application_fee DECIMAL(10,2);
ALTER TABLE payments ADD COLUMN stripe_fee DECIMAL(10,2);
ALTER TABLE payments ADD COLUMN coach_payout DECIMAL(10,2);
ALTER TABLE payments ADD COLUMN exchange_rate DECIMAL(10,6);
ALTER TABLE payments ADD COLUMN original_amount DECIMAL(10,2);
ALTER TABLE payments ADD COLUMN original_currency VARCHAR(3);

-- Payment disputes & refunds
CREATE TABLE payment_disputes (
    id UUID PRIMARY KEY,
    payment_id UUID REFERENCES payments(id),
    stripe_dispute_id VARCHAR(100),
    status VARCHAR(30),
    amount DECIMAL(10,2),
    currency VARCHAR(3),
    reason VARCHAR(100),
    evidence JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**IMPACT :**
- Logique comptable complexe (multi-devises, commissions, fees)
- Gestion des webhooks Stripe
- Compliance réglementaire par pays
- Gestion des litiges et remboursements

### 4. Système de notifications avancé

**NOUVEAUX BESOINS :**
```sql
-- Templates notifications multi-langue
CREATE TABLE notification_templates (
    id UUID PRIMARY KEY,
    template_key VARCHAR(100),    -- booking_confirmed, payment_received, etc.
    channel VARCHAR(20),          -- push, email, sms
    locale_code VARCHAR(5),
    subject TEXT,                 -- Pour emails
    body_template TEXT,           -- Avec variables {{user.name}}
    created_at TIMESTAMP DEFAULT NOW()
);

-- Envois de notifications
CREATE TABLE notification_logs (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    template_id UUID REFERENCES notification_templates(id),
    channel VARCHAR(20),
    destination VARCHAR(200),     -- Email, phone, device_token
    variables JSONB,              -- Variables utilisées dans template
    status VARCHAR(30),           -- sent, failed, opened, clicked
    sent_at TIMESTAMP,
    opened_at TIMESTAMP,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- User preferences notifications
CREATE TABLE user_notification_preferences (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    channel VARCHAR(20),
    notification_type VARCHAR(50),
    enabled BOOLEAN DEFAULT true,
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    timezone VARCHAR(50)
);
```

### 5. Système de fichiers avancé

**NOUVEAUX BESOINS :**
```sql
-- File management centralisé
CREATE TABLE files (
    id UUID PRIMARY KEY,
    owner_id UUID REFERENCES users(id),
    filename VARCHAR(255),
    original_filename VARCHAR(255),
    mime_type VARCHAR(100),
    file_size BIGINT,
    storage_path TEXT,           -- S3 path ou local path
    access_url TEXT,             -- URL publique si applicable
    file_category VARCHAR(50),   -- profile_photo, certification, etc.
    metadata JSONB,              -- Dimensions, exif, etc.
    created_at TIMESTAMP DEFAULT NOW()
);

-- Relations files vers entités
CREATE TABLE file_attachments (
    id UUID PRIMARY KEY,
    file_id UUID REFERENCES files(id),
    entity_type VARCHAR(50),     -- coach_profile, workout_program, etc.
    entity_id UUID,
    attachment_type VARCHAR(50), -- main_photo, certificate, etc.
    sort_order INTEGER DEFAULT 0
);
```

### 6. Modèles métier étendus

**ÉVOLUTION DES TABLES EXISTANTES :**
```sql
-- Coach profiles enrichi
ALTER TABLE coach_profiles ADD COLUMN bio_translations JSONB;
ALTER TABLE coach_profiles ADD COLUMN certifications JSONB;
ALTER TABLE coach_profiles ADD COLUMN languages VARCHAR(20)[];
ALTER TABLE coach_profiles ADD COLUMN experience_years INTEGER;
ALTER TABLE coach_profiles ADD COLUMN profile_completion_percentage INTEGER;

-- Bookings avec complexité géographique
ALTER TABLE bookings ADD COLUMN location_type VARCHAR(30); -- gym, home, outdoor
ALTER TABLE bookings ADD COLUMN gym_id UUID REFERENCES gyms(id);
ALTER TABLE bookings ADD COLUMN address JSONB;
ALTER TABLE bookings ADD COLUMN timezone VARCHAR(50);
ALTER TABLE bookings ADD COLUMN booking_locale VARCHAR(5);

-- Gyms intégrés (nouvelles tables)
CREATE TABLE gym_chains (
    id UUID PRIMARY KEY,
    name VARCHAR(100),
    country_codes VARCHAR(2)[],
    total_locations INTEGER,
    api_integration_status VARCHAR(30)
);

CREATE TABLE gyms (
    id UUID PRIMARY KEY,
    chain_id UUID REFERENCES gym_chains(id),
    name VARCHAR(200),
    address JSONB,
    location POINT,             -- PostGIS pour géospatial
    amenities JSONB,
    opening_hours JSONB
);
```

---

## 📈 Analyse quantitative des écarts

### Complexité du schéma

| Métrique | MVP | V3 | Ratio |
|----------|-----|----|----|
| Tables | 6 | 28+ | **4.7x** |
| Colonnes total | ~40 | ~200+ | **5x** |
| Index requis | 8 | 50+ | **6x** |
| Contraintes FK | 5 | 35+ | **7x** |
| Triggers | 0 | 15+ | **∞** |
| JSONB colonnes | 0 | 12+ | **∞** |

### Volume de données estimé

| Entité | MVP (1 an) | V3 (1 an) | Multiplication |
|--------|-------------|-----------|----------------|
| Users | 1K | 50K+ | **50x** |
| Bookings | 5K | 200K+ | **40x** |
| Activities | 0 | 2M+ | **∞** |
| Translations | 0 | 5K+ | **∞** |
| Files | 100 | 100K+ | **1000x** |
| Notifications | 0 | 500K+ | **∞** |

### Complexité des requêtes

**MVP queries (simples) :**
```sql
-- Recherche coachs
SELECT * FROM coach_profiles 
WHERE specialties LIKE '%fitness%';

-- Bookings d'un coach
SELECT * FROM bookings 
WHERE coach_id = $1 AND status = 'confirmed';
```

**V3 queries (complexes) :**
```sql
-- Recherche coachs multi-locale avec distance géospatial
SELECT cp.*, 
       ST_Distance(g.location, ST_Point($lat, $lng)) as distance,
       t.translation_value as localized_bio
FROM coach_profiles cp
JOIN users u ON u.id = cp.user_id
LEFT JOIN translations t ON t.translation_key = 'bio.' || cp.user_id 
                        AND t.locale_code = $locale
LEFT JOIN gyms g ON g.id = ANY(cp.preferred_gyms)
WHERE u.locale_code IN ($supported_locales)
  AND ST_DWithin(g.location, ST_Point($lat, $lng), $radius_km * 1000)
ORDER BY distance, cp.rating DESC;

-- Sync dernières activités avec conflict resolution
WITH recent_activities AS (
  SELECT DISTINCT ON (external_id, provider) *
  FROM activities 
  WHERE user_id = $1 
    AND provider = $provider
    AND created_at > $last_sync
  ORDER BY external_id, provider, created_at DESC
)
INSERT INTO activities (...)
SELECT ... FROM external_api_data
ON CONFLICT (external_id, provider) 
DO UPDATE SET duration_seconds = EXCLUDED.duration_seconds
WHERE activities.created_at < EXCLUDED.created_at;
```

---

## 🚨 Migrations critiques requises

### 1. Migration i18n (Phase 1)
```sql
-- Ajout colonnes i18n
ALTER TABLE users ADD COLUMN locale_code VARCHAR(5) DEFAULT 'fr-FR';
ALTER TABLE users ADD COLUMN timezone VARCHAR(50) DEFAULT 'Europe/Paris';

-- Migration données existantes
UPDATE coach_profiles 
SET bio_translations = jsonb_build_object('fr-FR', bio)
WHERE bio IS NOT NULL;

-- Création tables traductions
-- (voir schémas au-dessus)
```

### 2. Migration multi-devises (Phase 2)
```sql
-- Ajout colonnes monétaires
ALTER TABLE bookings ADD COLUMN currency_code VARCHAR(3) DEFAULT 'EUR';
ALTER TABLE coach_profiles RENAME COLUMN hourly_rate TO hourly_rate_eur;

-- Création table pricing multi-devises
-- Migration des tarifs existants vers nouvelle structure
```

### 3. Migration files système (Phase 3)
```sql
-- Création système files
-- Migration des avatars/certifications existants vers nouveau système
-- Update des URLs dans les profils
```

---

## ⚡ Performance & scalabilité impacts

### Index stratégiques V3
```sql
-- Geospatial search
CREATE INDEX idx_gyms_location ON gyms USING gist(location);

-- I18n queries optimization  
CREATE INDEX idx_translations_lookup 
ON translations (locale_code, translation_key);

-- OAuth sync performance
CREATE INDEX idx_activities_user_sync 
ON activities (user_id, provider, created_at DESC);

-- Multi-currency pricing
CREATE INDEX idx_pricing_currency 
ON coach_pricing (coach_id, currency_code);
```

### Partitioning strategy
```sql
-- Partitioning par locale (distribution géographique)
CREATE TABLE users_partition_fr PARTITION OF users 
FOR VALUES IN ('fr-FR', 'fr-BE', 'fr-CH');

CREATE TABLE users_partition_en PARTITION OF users 
FOR VALUES IN ('en-US', 'en-GB');

-- Partitioning temporel pour activities (volume)
CREATE TABLE activities_2026_01 PARTITION OF activities
FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
```

---

## 📊 Résumé de l'impact

### Development effort estimation

| Composant | MVP effort | V3 effort | Multiplier |
|-----------|------------|-----------|-----------|
| Schema design | 1 semaine | 3-4 semaines | **4x** |
| Migrations | 0.5 semaine | 2-3 semaines | **5x** |
| ORM models | 1 semaine | 4-5 semaines | **5x** |
| Data validation | 0.5 semaine | 2-3 semaines | **5x** |
| Query optimization | 0.5 semaine | 2-3 semaines | **5x** |
| **TOTAL** | **3.5 semaines** | **13-18 semaines** | **~5x** |

### Technical risks

🔴 **CRITIQUES :**
1. **Data migration complexe** — risque de corruption pendant migration MVP→V3
2. **Performance degradation** — queries complexes + volume données 
3. **Consistency multi-provider** — conflict resolution données externes
4. **Compliance GDPR** — données PII + droit à l'oubli multi-tables

🟡 **IMPORTANTES :**
1. **Schema evolution** — migrations backward compatibility
2. **Multi-tenant isolation** — sécurité données par locale/pays
3. **Cache invalidation** — stratégies cache multi-langue

---

## 🎯 Recommandations stratégiques

### Approach proposée : **Migration progressive**

**Phase 1 (MVP++)** : Ajout i18n + multi-devises de base
**Phase 2 (V2)** : OAuth2 + intégrations + files système  
**Phase 3 (V3)** : Features avancées + optimisations

Cette approche permet de limiter les risques tout en progressant vers la V3 complète.

### Alternative : **Rewrite from scratch**
Considérer un rewrite complet si le MVP actuel devient un frein à l'évolution rapide vers V3. Le modèle de données V3 est suffisamment différent pour justifier cette approche.

**Décision à prendre rapidement** en fonction des contraintes timeline business.