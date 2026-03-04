# MyCoach - Roadmap de Développement Détaillée

> **Date :** 3 Mars 2026  
> **Status :** APPROVED - Prêt pour développement  
> **Équipe :** dev-python + dev-flutter + tester-flutter-qa  
> **Durée estimée MVP :** 6 semaines (2 devs en parallèle)

---

## 🎯 Vision Produit

**Plateforme mobile Flutter permettant aux coachs sportifs de gérer leurs clients et proposer des séances personnalisées avec paiements intégrés.**

### Stack technique confirmée
- **Frontend :** Flutter + Material Design 3 (Inter font, colorscheme #2563EB/#10B981)
- **Backend :** Python FastAPI + JWT auth + SQLite→PostgreSQL
- **APIs :** OpenAPI specs définies, format JSON REST + X-API-Key
- **Déploiement :** Docker containers

---

## 📋 Structure des Phases

### Légende Estimation Effort
- **XS :** 1-2 jours (composant simple, écran basique)
- **S :** 3-5 jours (logique business simple, API + UI)
- **M :** 1-2 semaines (fonctionnalité complète multi-écrans)
- **L :** 2-3 semaines (système complexe avec dépendances)

### Légende Priorité
- **P0 - MVP Critical :** Bloque le lancement, doit marcher parfaitement
- **P1 - Post-MVP :** Améliore UX, livré dans les 2 semaines post-MVP
- **P2 - V2 Future :** Fonctionnalités avancées, roadmap long-terme

---

## 🚀 PHASE 1 : Infrastructure & Auth (Semaine 1)
*Fondations techniques + authentification complète*

### 1.1 - Setup Infrastructure [dev-python + dev-flutter] 
**Effort :** M | **Priorité :** P0 | **Durée :** 3-4 jours | **Dépendances :** aucune

#### Tâches dev-python
- [ ] Setup projet FastAPI + structure modules (auth, users, coaches, clients)
- [ ] Configuration JWT + X-API-Key middleware
- [ ] Setup SQLite local + models SQLAlchemy (User, Coach, Client)
- [ ] Endpoints `/auth/register` + `/auth/login` avec validation email
- [ ] Docker setup + docker-compose.yml
- [ ] Documentation Swagger auto-générée
- [ ] Tests unitaires auth (pytest)

#### Tâches dev-flutter
- [ ] Création projet Flutter + structure folders (screens, widgets, services)
- [ ] Setup ThemeData Material 3 avec colorscheme défini
- [ ] Configuration GoogleFonts (Inter) + responsive helper
- [ ] Setup GoRouter avec navigation structure
- [ ] Service HTTP client + JWT interceptors
- [ ] Models Dart (User, Coach) + JSON serialization

#### Tests d'intégration
- [ ] Signup coach → email validation → login → JWT token valid
- [ ] Tests API contract avec Postman/Insomnia

### 1.2 - Écrans Auth UI [dev-flutter]
**Effort :** S | **Priorité :** P0 | **Durée :** 2-3 jours | **Dépendances :** 1.1

#### Tâches
- [ ] **Écran 1 - Splash Screen** : Logo + animations + routing logic
- [ ] **Écran 2 - Login** : Form validation + error handling + "Mot de passe oublié"
- [ ] **Écran 3 - Register** : Form + password strength + validation temps réel
- [ ] NavigationService + AuthService intégration
- [ ] Loading states + error SnackBars + transitions SlideTransition
- [ ] Tests widget pour tous les écrans auth

#### Critères d'acceptation
- ✅ Splash screen affichée 2s minimum, puis redirect selon token
- ✅ Login/Register avec validation native + messages erreur français
- ✅ Password strength indicator fonctionnel (faible→excellent)
- ✅ Signup → email validation obligatoire → login automatique
- ✅ Transitions fluides 300ms entre écrans

---

## 🏗️ PHASE 2 : Profils & Navigation (Semaine 2)
*Dashboard coach + système de profils + navigation principale*

### 2.1 - Dashboard Coach Foundation [dev-flutter + dev-python]
**Effort :** L | **Priorité :** P0 | **Durée :** 4-5 jours | **Dépendances :** 1.1, 1.2

#### Tâches dev-python
- [ ] Endpoints `/coaches/me` (GET/PUT) avec profil complet
- [ ] Model Coach extended : bio, country, specialties, certifications, rates
- [ ] Logic `profile_complete` % calculation (bio, spécialités, certifs, tarifs)
- [ ] Endpoints stats rapides : `/coaches/stats` (nb clients, programmes, messages)
- [ ] Validation business rules : spécialités liste fixe, tarifs min/max, durées
- [ ] Tests unitaires + fixtures Coach complète

#### Tâches dev-flutter
- [ ] **NavigationBar persistante** : 5 tabs avec badges + indicateurs
- [ ] **Écran 4 - Dashboard Coach** : Header + stats cards + séances jour + clients récents
- [ ] **Écran 12 - Profil Coach** : Affichage/édition profil + photo + settings
- [ ] Widgets réutilisables : StatsCard, ClientListTile, SessionCard
- [ ] States management : profil loading/error + refresh logique
- [ ] Profile completion flow + onboarding hints

#### Points critiques résolus
- **Flow onboarding :** Après signup → redirect Dashboard avec profile_complete < 50% → hints UI persistent
- **Gestion photos :** Upload via `/upload` endpoint + validation MIME + compression côté Flutter

### 2.2 - Système Upload & Photos [dev-python + dev-flutter]
**Effort :** M | **Priorité :** P0 | **Durée :** 2-3 jours | **Dépendances :** 2.1

#### Tâches dev-python
- [ ] Endpoint `/upload` multi-part form + validation MIME (jpg/png max 5MB)
- [ ] Storage local + serve static files + CDN ready structure
- [ ] Image compression Pillow + thumbnails generation
- [ ] Links photos → profils (Coach.profile_image_url)

#### Tâches dev-flutter
- [ ] ImagePicker integration + compression flutter_image_compress
- [ ] Upload service + progress indicators
- [ ] CachedNetworkImage + placeholder shimmer

---

## 👥 PHASE 3 : Gestion Clients (Semaine 3)
*CRUD clients + recherche + fiche détaillée + limite 15 clients*

### 3.1 - Backend Gestion Clients [dev-python]
**Effort :** L | **Priorité :** P0 | **Durée :** 3-4 jours | **Dépendances :** 2.1

#### Tâches dev-python
- [ ] Models Client + CoachClientRelationship avec statuts
- [ ] Endpoints CRUD `/clients` : create, list, get, update, archive
- [ ] Logic relationship_status auto : active si session < 30 jours
- [ ] Filtres `/clients?status=active&search=nom` + pagination 50/page
- [ ] Limite business : max 15 clients par coach (plan gratuit)
- [ ] Stats client : total_sessions, last_session_date, total_paid, outstanding_balance
- [ ] Tests coverage complète + fixtures multiple coaches

### 3.2 - UI Gestion Clients [dev-flutter]
**Effort :** L | **Priorité :** P0 | **Durée :** 4-5 jours | **Dépendances :** 3.1

#### Tâches dev-flutter
- [ ] **Écran 5 - Liste Clients** : SearchBar + FilterChips + ListView + pagination
- [ ] **Écran 6 - Fiche Client Détaillée** : SliverAppBar + TabBar (Résumé/Programmes/Historique)
- [ ] BottomSheet ajout client : Form validation + limite 15/15 checks
- [ ] Actions swipe : archiver (orange) + contextual menu (edit/delete)
- [ ] States : empty state + loading shimmer + search empty results
- [ ] Client badge counter 12/15 avec colors progressive (vert→orange→rouge)

#### Critères d'acceptation FIRM
- ✅ Limite 15 clients stricte : FAB disable + tooltip si 15/15
- ✅ Badge visual 12/15 en header avec couleurs UX (12→vert, 13-14→orange, 15→rouge)
- ✅ SearchBar temps réel + FilterChips fonctionnels
- ✅ Fiche client : tabs fonctionnelles + données cohérentes
- ✅ Actions rapides : archiver, éditer, supprimer avec confirmations

### 3.3 - Tests QA Gestion Clients [tester-flutter-qa]
**Effort :** S | **Priorité :** P0 | **Durée :** 2 jours | **Dépendances :** 3.2

#### Scénarios BDD/Gherkin
```gherkin
Feature: Gestion des clients coach
  Scenario: Ajout client jusqu'à limite
    Given Je suis connecté comme coach avec 14 clients
    When J'ajoute un nouveau client "Marie Dupont"
    Then Le badge affiche "15/15" rouge
    And Le FAB est désactivé
    And Le tooltip affiche "Limite atteinte - passez à Premium"

  Scenario: Recherche et filtres clients
    Given J'ai 8 clients actifs et 3 inactifs
    When Je tape "Marie" dans la recherche
    Then Seuls les clients contenant "Marie" sont affichés
    When Je sélectionne le filtre "Actifs"
    Then Seuls les 8 clients actifs sont affichés
```

---

## 📅 PHASE 4 : Système de Réservation (Semaine 4-5)
*Le cœur métier : booking des séances avec disponibilités*

### 4.1 - Backend Booking System [dev-python]
**Effort :** L | **Priorité :** P0 | **Durée :** 5-6 jours | **Dépendances :** 3.1

#### Tâches critiques dev-python
- [ ] **RÉSOLUTION POINT BLOQUANT :** Architecture disponibilités coaches
  - Logic : Coach définit recurring availabilities (lundi 9h-12h + 14h-18h)
  - Calcul slots libres = disponibilités - bookings existants
  - Algorithm côté backend pour éviter race conditions
- [ ] Models : CoachAvailability (day_of_week, start_time, end_time, duration_slot)
- [ ] Models : Booking (coach, client, date, start_time, duration, status, price)
- [ ] Endpoints `/coaches/{id}/availability` (GET/POST/PUT/DELETE)
- [ ] Endpoints `/bookings` (POST create, GET list, PUT status)
- [ ] Endpoints `/coaches/{id}/free-slots?date=2026-03-05` pour client
- [ ] Business rules : 
  - Booking auto-expire après 24h si pas confirmed
  - Overlap detection + validation créneaux
  - Rate calculation selon type (single_session, discovery)
- [ ] Background task : auto-expire bookings + notifications
- [ ] Tests complexes : créneaux, overlaps, edge cases

#### Architecture technique disponibilités
```python
# Récurrence coach : "Lundi 9h-12h, Mardi 14h-18h"
coach_availability = [
  {"day": 1, "start": "09:00", "end": "12:00", "slot_duration": 60},
  {"day": 2, "start": "14:00", "end": "18:00", "slot_duration": 60}
]

# Calcul free slots pour date donnée
def get_free_slots(coach_id, date):
  weekday = date.weekday()
  availability = get_coach_availability(coach_id, weekday)
  existing_bookings = get_bookings(coach_id, date)
  return calculate_available_slots(availability, existing_bookings)
```

### 4.2 - UI Recherche & Réservation [dev-flutter]
**Effort :** L | **Priorité :** P0 | **Durée :** 5-6 jours | **Dépendances :** 4.1

#### Tâches dev-flutter
- [ ] **Recherche Coachs** : Endpoint `/coaches` public avec filtres pays/spécialité
- [ ] **Booking Flow** : Sélection coach → calendrier → créneaux disponibles → confirmation
- [ ] **Calendar Widget** : table_calendar avec slots disponibles highlighted
- [ ] **Time Slots UI** : Grid des créneaux libres avec durées + tarifs
- [ ] **Booking Confirmation** : Récap + message optionnel + validation
- [ ] **Gestion côté Coach** : Liste bookings pending/confirmed + actions confirm/cancel
- [ ] States complexes : loading slots, booking en cours, success/error

#### Points UX critiques
- **Timezone handling :** Stockage UTC backend + affichage timezone local
- **Real-time availability :** Refresh slots si booking simultané détecté
- **Offline graceful :** Message clair si pas de réseau pendant booking

### 4.3 - Tests QA Booking System [tester-flutter-qa]
**Effort :** M | **Priorité :** P0 | **Durée :** 3-4 jours | **Dépendances :** 4.2

#### Scénarios critiques BDD
```gherkin
Feature: Réservation de séances
  Scenario: Réservation réussie
    Given Un coach "Jean" disponible lundi 9h-10h
    And Je suis connecté comme client
    When Je recherche des coachs pour lundi
    And Je sélectionne "Jean" à 9h00 pour 60min
    And Je confirme la réservation
    Then Le booking est créé en statut "pending"
    And Le coach reçoit la notification
    And Le créneau n'apparaît plus disponible

  Scenario: Créneau pris par un autre client
    Given Un coach avec un seul créneau libre lundi 9h
    And Deux clients tentent de réserver simultanément
    When Le premier confirme sa réservation
    Then Le second reçoit "Ce créneau n'est plus disponible"
    And Il est redirigé vers la sélection de créneaux
```

---

## 💰 PHASE 5 : Paiements & Finalisations (Semaine 6)
*Paiements manuels + historique + finalisations MVP*

### 5.1 - Système Paiements [dev-python]
**Effort :** M | **Priorité :** P0 | **Durée :** 3-4 jours | **Dépendances :** 4.1

#### Tâches dev-python
- [ ] Models : Payment (client, coach, amount, currency, method, reference, date)
- [ ] Logic : outstanding_balance calculation par client
- [ ] Endpoints `/payments` (POST create, GET history par client)
- [ ] Business rules : balance update automatique, currency validation
- [ ] Reporting : revenus coach par période, méthodes paiement stats

### 5.2 - UI Paiements [dev-flutter]
**Effort :** S | **Priorité :** P0 | **Durée :** 2-3 jours | **Dépendances :** 5.1

#### Tâches dev-flutter
- [ ] **Form Paiement Reçu** : montant + devise + méthode + référence + notes
- [ ] **Historique Paiements** par client dans fiche détaillée
- [ ] **Balance Widget** dans liste clients : solde positif (vert) / négatif (rouge)
- [ ] Validation : montant > 0, devise cohérente, méthodes fixes

### 5.3 - Polish MVP & Optimisations [dev-flutter]
**Effort :** M | **Priorité :** P0 | **Durée :** 2-3 jours | **Dépendances :** 5.2

#### Tâches de finalisation
- [ ] **Performance :** ListView.builder partout, CachedNetworkImage, pagination lazy loading
- [ ] **Error Handling :** Messages français cohérents, retry mechanisms, offline mode graceful
- [ ] **Loading States :** Shimmer effects unified, CircularProgressIndicator themed
- [ ] **Transitions :** SlideTransition 300ms easeInOutCubic entre tous les écrans
- [ ] **Polish UI :** Spacing final, colors corrections, accessibility improvements
- [ ] **Tests End-to-End :** User journey complet Coach signup → client booking → paiement

### 5.4 - Tests Regression & Performance [tester-flutter-qa]
**Effort :** M | **Priorité :** P0 | **Durée :** 3-4 jours | **Dépendances :** 5.3

#### Tests critiques pre-launch
- [ ] **Regression Testing :** Tous les scénarios P0 re-testés après optimisations
- [ ] **Performance Testing :** Temps de lancement < 3s, navigation fluide 60fps
- [ ] **Stress Testing :** 15 clients max, 50+ bookings, pagination efficace
- [ ] **Accessibility Testing :** Contrast ratio, touch targets 48dp, screen readers
- [ ] **Device Testing :** iPhone 14, Galaxy S23, tablet responsive

---

## 📈 PHASE 6 : Post-MVP Features (Semaines 7-9)
*Fonctionnalités P1 pour améliorer l'expérience*

### 6.1 - Disponibilités Récurrentes [US-010]
**Effort :** L | **Priorité :** P1 | **Durée :** 1-2 semaines

#### Scope
- Coach définit ses horaires hebdomadaires récurrents
- UI calendar picking avec patterns (tous les lundis 9h-12h)
- Override exceptions (congés, créneaux spéciaux)
- Bulk generation des créneaux disponibles

### 6.2 - Packages & Forfaits [US-011]
**Effort :** L | **Priorité :** P1 | **Durée :** 1-2 semaines

#### Scope  
- Coach crée forfaits : "5 séances = 200€" avec réduction
- Client achète package → crédit séances dans son compte
- Booking consomme crédit package ou paiement unitaire
- Tracking : séances restantes, expiration forfait

### 6.3 - Profil Client Avancé [US-013]
**Effort :** S | **Priorité :** P1 | **Durée :** 3-5 jours

#### Scope
- Client complète : objectifs, niveau fitness, blessures, préférences
- Coach voit profil client enrichi pour personnalisation
- Matching suggestions basées sur profils compatibles

---

## 🔮 PHASE 7 : V2 Future Features (Long-terme)
*Fonctionnalités P2 pour différenciation concurrentielle*

### 7.1 - Programmes d'Entraînement [US-014]
**Effort :** L | **Priorité :** P2 | **Durée :** 2-3 semaines

#### Scope
- Coach crée programmes structurés : exercices + sets + progressions
- Assignment programmes aux clients avec tracking progression
- Bibliothèque exercices avec vidéos + instructions
- Analytics performances client

### 7.2 - Chat Temps Réel [Actuellement Won't Have]
**Effort :** L | **Priorité :** P2 | **Durée :** 2-3 semaines

#### Scope
- WebSocket real-time messaging
- Media sharing (photos, vidéos)
- Notifications push
- Historique conversations persistant

### 7.3 - Intégrations Fitness Apps [US-016]
**Effort :** L | **Priorité :** P2 | **Durée :** 2-3 semaines

#### Scope
- Sync Apple Health / Google Fit
- Import séances automatiques
- Analytics performance cross-platform
- Wearables integration

---

## 🎯 Définition of Done (DoD) par Phase

### ✅ Phase complétée quand :
1. **Code Quality :**
   - ✅ Tous tests unitaires PASS (coverage > 80%)
   - ✅ Tests BDD/Gherkin validés par QA
   - ✅ Code review approuvé dev senior
   - ✅ Aucun bug critique/bloquant

2. **Functionality :**
   - ✅ User stories P0 100% fonctionnelles
   - ✅ Error handling graceful tous scenarios
   - ✅ Performance acceptable (< 3s load, 60fps navigation)
   - ✅ UI/UX conforme maquettes

3. **Documentation :**
   - ✅ API documentation Swagger à jour
   - ✅ README technique mis à jour
   - ✅ Notes de release rédigées

---

## ⚠️ Risques Identifiés & Mitigations

### 🔴 Risques Critiques
1. **Complexité disponibilités coaches**
   - **Mitigation :** Architecture simple en Phase 4.1, itération progressive
   - **Plan B :** Disponibilités manuelles event-by-event si récurrence trop complexe

2. **Race conditions booking simultané**  
   - **Mitigation :** Database locks + validation backend strict
   - **Plan B :** Queue system si load important

3. **Performance Flutter avec 15+ clients**
   - **Mitigation :** Pagination + lazy loading systematique
   - **Plan B :** Optimisation FPS + memory si needed

### 🟡 Risques Importants
4. **Timezone confusion client/coach**
   - **Mitigation :** UTC storage + clear UI timezone display

5. **Upload images performance**
   - **Mitigation :** Compression + thumbnails + CDN ready

6. **Tests BDD coverage insufficient**
   - **Mitigation :** QA impliqué dès Phase 2, scenarios rédigés early

---

## 📊 Métriques de Succès MVP

### Fonctionnelles
- ✅ Coach peut onboard complet < 10min
- ✅ Client peut booker séance < 3min  
- ✅ 95% bookings confirmés sous 24h
- ✅ 0 crash app pendant user journey principal
- ✅ Temps response API < 500ms (95e percentile)

### Business  
- ✅ Taux conversion signup → profil complete > 70%
- ✅ Taux rétention J7 coaches > 60%
- ✅ NPS early users > 50

### Techniques
- ✅ App size < 50MB
- ✅ Cold start < 3s sur device mid-range
- ✅ Crash rate < 1%
- ✅ API uptime > 99.5%

---

## 🚀 Go-Live Plan

### Pre-Launch (Fin Semaine 6)
- [ ] **Staging Deployment :** Environment production-ready
- [ ] **Beta Test :** 5 coachs early adopters + 10 clients test
- [ ] **Security Audit :** sysadmin validation complete  
- [ ] **Performance Load Test :** 50 concurrent users
- [ ] **App Store Preparation :** Screenshots, description, keywords

### Launch Day
- [ ] **Production Deployment :** Backend + App Store release
- [ ] **Monitoring Setup :** Logs, analytics, crash reporting
- [ ] **Support Ready :** FAQ, contact channels
- [ ] **Marketing Activation :** Communication launch

### Post-Launch (Semaines 7-8) 
- [ ] **Monitoring 48h** : Crash rate, performance, user feedback
- [ ] **Hot-fix Ready** : Critical bugs response < 2h
- [ ] **Feedback Collection** : Reviews analysis + roadmap ajustements
- [ ] **Iteration Planning** : P1 features priority based on user data

---

## 📞 Coordination Équipe

### Sync Points Hebdomadaires
- **Lundi 9h :** Planning semaine + blockers identification
- **Mercredi 17h :** Mid-week progress + ajustements
- **Vendredi 16h :** Démos + retrospective + planning semaine suivante

### Communication Channels
- **#dev-python :** Backend progress + API changes
- **#dev-flutter :** Frontend progress + UI questions  
- **#qa-flutter :** Tests results + bugs reports
- **#product-backlog :** Product decisions + specs clarifications

### Handoffs Critiques
1. **Phase 1→2 :** Auth endpoints validés → UI auth démarrage
2. **Phase 2→3 :** Dashboard foundation → Gestion clients développement
3. **Phase 4.1→4.2 :** Booking backend complet → Frontend booking development
4. **Phase 5→6 :** MVP code freeze → Post-MVP features kickoff

---

**🎯 STATUT ROADMAP : PRÊT POUR DÉVELOPPEMENT**

*Cette roadmap détaille 6 semaines de développement MVP + 3 semaines post-MVP. Chaque phase est découpée en tâches précises avec estimations réalistes et dépendances claires. L'équipe peut démarrer Phase 1 immédiatement.*

**Next Action :** Lancement Phase 1 - Infrastructure & Auth dès que dev-python + dev-flutter confirment disponibilité.