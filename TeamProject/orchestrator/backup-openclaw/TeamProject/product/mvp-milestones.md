# MVP Milestones MyCoach - Product Manager

## 🎯 Roadmap MVP — Jalons et critères d'acceptation

> **Version :** v1.0 MVP  
> **Date :** 02 Mars 2026  
> **Durée estimée :** 5-6 semaines  
> **Équipes :** dev-python + dev-flutter

---

## 📋 Milestone 1 : Foundation Auth (S1-S2)

**Objectif :** Inscription, login et base technique  
**Durée :** 1,5 semaines  
**Priorité :** 🔴 CRITIQUE

### ✅ Critères d'acceptation — Backend (dev-python)

- [ ] **API Auth endpoints opérationnels**
  - POST `/auth/register` avec validation email
  - POST `/auth/login` avec JWT generation
  - Middleware JWT pour routes protégées
  - Hashage bcrypt passwords
  
- [ ] **Base données initialisée**
  - Tables users, coaches, clients, bookings, payments
  - Migrations Alembic fonctionnelles
  - Seeds data pour tests locaux

- [ ] **Documentation API**
  - Swagger UI accessible `/docs`
  - Tous endpoints documentés avec exemples
  - Schemas de validation Pydantic

### ✅ Critères d'acceptation — Frontend (dev-flutter)

- [ ] **Screens Auth fonctionnels**
  - Signup screen avec validation forms
  - Login screen avec error handling
  - Navigation role-based (coach vs client)
  - Token storage sécurisé (SharedPreferences)

- [ ] **State management configuré**
  - Provider/Riverpod pour auth state
  - Persistence login automatique
  - Logout + cleanup token

- [ ] **HTTP client configuré**
  - Dio/http interceptors pour JWT
  - Error handling standardisé
  - Base URLs environment (dev/prod)

### 🎯 Demo Milestone 1
- Coach peut s'inscrire, recevoir email validation, se login
- Client peut s'inscrire, se login, voir interface client vide
- JWT tokens functional + auto-refresh

---

## 📋 Milestone 2 : Coach Profile & Onboarding (S2-S3)

**Objectif :** Profil coach complet + onboarding UX  
**Durée :** 1,5 semaines  
**Priorité :** 🔴 CRITIQUE

### ✅ Critères d'acceptation — Backend (dev-python)

- [ ] **Coach profile endpoints**
  - GET/PUT `/coaches/me` avec toutes les données profil
  - Upload endpoint pour photos + certifications
  - Validation business rules (tarifs, spécialités)
  - Calcul `profile_complete` % auto

- [ ] **File upload système**
  - Storage local ou S3-compatible
  - Validation MIME types + taille
  - Génération URLs publicly accessible
  - Cleanup files orphelins

### ✅ Critères d'acceptation — Frontend (dev-flutter)

- [ ] **Onboarding coach complet**
  - Stepper/wizard multi-étapes
  - Upload photos avec preview
  - Sélection spécialités (liste prédéfinie)
  - Configuration tarifs + politique annulation

- [ ] **Profile completion tracking**
  - Progress bar visuel %
  - Prompts pour compléter sections manquantes
  - Skip possible mais navigation claire vers profile

- [ ] **Forms validation robuste**
  - Validation client-side + backend sync
  - Error messages user-friendly français
  - Sauvegarde automatique drafts

### 🎯 Demo Milestone 2
- Coach après login passe par onboarding complet
- Profile completion 100% accessible et modifiable
- Upload photos + certifs fonctionnel

---

## 📋 Milestone 3 : Client Search & Coach Discovery (S3-S4)

**Objectif :** Recherche coachs + pages détails  
**Durée :** 1 semaine  
**Priorité :** 🔴 CRITIQUE

### ✅ Critères d'acceptation — Backend (dev-python)

- [ ] **Search endpoints**
  - GET `/coaches` avec filtres pays, spécialité
  - Pagination performance (limit/offset)
  - Privacy : noms familles masqués en liste
  - Calcul tarifs min/max par coach

### ✅ Critères d'acceptation — Frontend (dev-flutter)

- [ ] **Search & discovery UI**
  - Liste coachs avec cards design
  - Filtres par pays (dropdown required)
  - Pagination scroll infini ou bouton "Load more"
  - Search bar par nom coach

- [ ] **Coach detail page**
  - Affichage profil complet public
  - Gallery photos + certifications
  - Tarifs clairs + politique annulation
  - Button "Réserver une séance"

### 🎯 Demo Milestone 3
- Client peut chercher coachs par pays
- Filtrage par spécialité functional
- Détail coach avec toutes infos accessibles

---

## 📋 Milestone 4 : Booking System Core (S4-S5)

**Objectif :** Système réservation complet  
**Durée :** 2 semaines  
**Priorité :** 🔴 CRITIQUE

### ✅ Critères d'acceptation — Backend (dev-python)

- [ ] **Booking endpoints complets**
  - POST `/bookings` avec validation créneaux
  - GET `/bookings` avec filtres status + role
  - PUT `/bookings/{id}/status` coach confirmation
  - Auto-expire bookings pending après 24h

- [ ] **Availability system**
  - **DÉCISION REQUISE** : Slots management algorithm
  - Conflict detection réservations
  - Timezone handling UTC → local display

- [ ] **Business rules enforcement**
  - Validation durée séances (15-480min)
  - Délai annulation policy respect
  - Pricing calculation auto from coach rates

### ✅ Critères d'acceptation — Frontend (dev-flutter)

- [ ] **Booking flow complet**
  - Calendar picker avec créneaux dispos
  - Sélection durée + tarif applicable
  - Message client au coach (500 char max)
  - Confirmation summary avant submit

- [ ] **Booking management**
  - Liste bookings par statut (pending, confirmed, etc.)
  - Actions coach : confirm/cancel avec message
  - Notifications status changes (local notifs)
  - Historique complet accessible

### 🎯 Demo Milestone 4
- Client peut réserver séance avec coach
- Coach reçoit demande et peut confirmer/refuser
- System gère les conflicts + auto-expiry

---

## 📋 Milestone 5 : Client Management & Payments (S5-S6)

**Objectif :** Gestion clients + paiements manuels  
**Durée :** 1 semaine  
**Priorité :** 🔴 CRITIQUE MVP

### ✅ Critères d'acceptation — Backend (dev-python)

- [ ] **Client relationship management**
  - GET `/clients` avec calculs balances
  - Auto-calculation relationship status (active/inactive)
  - Outstanding balance = facturé - payé
  - Historique sessions + payments par client

- [ ] **Manual payments system**
  - POST `/payments` enregistrement coach
  - Recalcul auto balances après payment
  - Support multiple payment methods
  - Tracking références transactions

### ✅ Critères d'acceptation — Frontend (dev-flutter)

- [ ] **Client management UI**
  - Liste clients avec infos clés (sessions, balance)
  - Fiche client détaillée avec historique
  - Indicateurs visuels clients en retard paiement
  - Search/filter clients by status

- [ ] **Payment recording**
  - Form paiement simple + rapide
  - Sélection client existant
  - Support cash, card, virement, etc.
  - Confirmation visual + balance updated

### 🎯 Demo Milestone 5
- Coach peut voir tous ses clients + balances
- Enregistrement paiements avec recalcul auto
- Tracking impayés + relationship status

---

## 📋 Milestone 6 : Integration & Polish (S6)

**Objectif :** Tests intégration + UX finale  
**Durée :** 0,5 semaine  
**Priorité :** 🟡 POLISH

### ✅ Critères d'acceptation — Full Stack

- [ ] **End-to-end testing**
  - Journey client complet : signup → search → book → confirm
  - Journey coach complet : signup → profile → manage bookings → payments
  - Error handling scenarios tested
  - Performance acceptable sur devices moyens

- [ ] **UX/UI polish**
  - Loading states sur toutes les actions async
  - Error messages français user-friendly
  - Navigation fluide entre sections
  - Responsive design pour tablets

- [ ] **MVP Production ready**
  - Environment variables configuration
  - Basic monitoring/logs setup
  - Security headers + CORS correct
  - Database backup strategy

### 🎯 Demo Milestone 6
- Demo live complete user journey A→Z
- Performance acceptable + error handling robust
- Ready for beta testers onboarding

---

## 🚨 Points de blocage identifiés

### 🔴 CRITIQUES (stoppers)

1. **Architecture disponibilités créneaux**
   - Backend algorithm vs Flutter local calculation ?
   - Recurring availability vs event-based ?
   - Timezone synchronization strategy ?
   
   **DÉCISION REQUISE D+1** avant Milestone 4

2. **Flow onboarding sequence**
   - Profile completion mandatory vs optional ?
   - Progressive disclosure vs all-at-once ?
   - Default values + skip strategies ?
   
   **DÉCISION REQUISE D+3** avant Milestone 2

3. **File upload strategy**
   - Local storage vs cloud (S3) ?
   - CDN pour performance images ?
   - Compression client-side vs server-side ?
   
   **DÉCISION REQUISE D+5** avant Milestone 2

### 🟡 IMPORTANTES (impact UX)

4. **Error handling standardization**
   - Codes erreur API standardisés ?
   - i18n strategy error messages ?
   - Offline handling strategy ?

5. **Performance optimization**
   - Images lazy loading + caching ?
   - API response caching strategy ?
   - Database indexing strategy ?

---

## 📊 Success Metrics MVP

### 📈 Business Metrics

- **Coach adoption :** 10+ profils complets créés
- **Booking completion rate :** >70% des demandes confirmées
- **Payment recording :** >50% des coachs utilisent feature paiements
- **Retention D7 :** >60% des users reviennent après 1 semaine

### ⚡ Technical Metrics

- **API response times :** <500ms P95 sur endpoints critiques
- **App startup time :** <3s cold start
- **Crash rate :** <2% sessions
- **Bundle size :** <50MB app Flutter

### 🎯 Completion Criteria

**MVP READY quand :**
- [ ] Tous les Milestones 1-5 ✅ validés
- [ ] E2E tests passing sur user journeys critiques  
- [ ] Performance metrics dans les targets
- [ ] Security audit basic passed
- [ ] 3+ beta testers ont complété full journey sans blocage majeur

---

## 🔄 Coordination avec dev teams

### Daily sync points
- **dev-python :** API endpoints status + blockers
- **dev-flutter :** UI implementation + integration issues  
- **product :** Requirements clarification + acceptance validation

### Weekly milestones review
- Demo milestone achievements
- Blockers resolution collaborative
- Next milestone planning + resource allocation
- Business feedback integration