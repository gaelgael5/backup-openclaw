# Parcours Utilisateurs Critiques MyCoach

## 🎯 User Journeys P0 - MVP Critical Paths

### Méthodologie de Test
- **BDD/Gherkin** : Scenarios écrites en langage naturel (.feature files)  
- **Test Coverage** : 100% des user stories P0 avec variantes success/error
- **Cross-platform** : Validation Android + iOS pour chaque parcours
- **Performance** : Benchmarks sur chaque parcours critique

---

## 👨‍🏋️ JOURNEY 1: Onboarding Coach Complet

### US-001 + US-004: De l'inscription à profil opérationnel

#### Happy Path Principal
```gherkin
Feature: Onboarding Coach Complet

Background:
  Given l'application MyCoach est lancée
  And aucun utilisateur n'est connecté

Scenario: Coach s'inscrit et configure son profil complet
  # Étape 1: Inscription
  When l'utilisateur sélectionne "Je suis Coach"  
  And saisit "coach.test@example.com" comme email
  And saisit "CoachPass123!" comme mot de passe
  And confirme le mot de passe "CoachPass123!"
  And saisit "Jean" comme prénom
  And saisit "Dupont" comme nom  
  And appuie sur "Créer mon compte"
  
  # Étape 2: Validation email (simulée)
  Then le message "Email de validation envoyé" est affiché
  When l'email est validé via le lien (simulation backend)
  
  # Étape 3: Premier login
  And l'utilisateur se connecte avec "coach.test@example.com" / "CoachPass123!"
  Then l'utilisateur arrive sur l'écran "Configuration Profil"
  
  # Étape 4: Configuration profil
  When l'utilisateur saisit "Expert en musculation et fitness" comme bio
  And sélectionne "France" comme pays
  And sélectionne "EUR" comme devise
  And définit "60" minutes comme durée séance par défaut  
  And ajoute la spécialité "Musculation"
  And ajoute la spécialité "Fitness"
  And configure le tarif "Discovery" à "30" EUR
  And configure le tarif "Regular" à "50" EUR
  And définit la politique d'annulation "24h avant sans frais"
  And appuie sur "Finaliser Profil"
  
  Then l'utilisateur arrive sur le dashboard coach
  And voit "Profil configuré" comme statut
  And voit "0 clients" dans les statistiques  
  And voit "0 réservations en attente"
```

#### Variantes et Edge Cases
```gherkin
Scenario: Email déjà utilisé
  When l'utilisateur tente de s'inscrire avec "existing@example.com"  
  Then le message "Email déjà utilisé" est affiché
  And l'utilisateur reste sur l'écran d'inscription

Scenario: Mot de passe trop faible
  When l'utilisateur saisit "123" comme mot de passe
  Then le message "Mot de passe trop faible" est affiché  
  And le bouton "Créer compte" est désactivé

Scenario: Profil partiellement rempli
  When l'utilisateur remplit bio et pays seulement
  And appuie sur "Finaliser Profil"  
  Then les champs manquants sont surlignés en rouge
  And le message "Veuillez remplir tous les champs obligatoires" s'affiche
```

#### Tests Performance Journey 1
- ⏱️ **Signup complet** : < 10 secondes end-to-end
- ⏱️ **Navigation profil** : < 2 secondes entre steps  
- 💾 **Memory usage** : < 200MB pendant onboarding
- 🔄 **Network calls** : < 8 API calls total

---

## 🏃‍♀️ JOURNEY 2: Onboarding Client + Première Recherche

### US-002 + US-005: De l'inscription à la découverte de coachs

#### Happy Path Principal  
```gherkin
Feature: Onboarding Client + Recherche

Background:
  Given l'application MyCoach est lancée
  And au moins 5 coachs sont disponibles dans le système

Scenario: Client s'inscrit et trouve des coachs
  # Étape 1: Inscription client
  When l'utilisateur sélectionne "Je cherche un Coach"
  And saisit "client.test@example.com" comme email  
  And saisit "ClientPass123!" comme mot de passe
  And confirme le mot de passe "ClientPass123!"
  And saisit "Alice" comme prénom
  And saisit "Martin" comme nom
  And appuie sur "Créer mon compte"
  
  # Étape 2: Validation et login  
  Then le message "Email de validation envoyé" est affiché
  When l'email est validé via le lien
  And l'utilisateur se connecte avec "client.test@example.com" / "ClientPass123!"
  
  # Étape 3: Découverte des coachs
  Then l'utilisateur arrive sur l'écran "Recherche Coachs"
  And voit au moins 5 coachs dans la liste
  And chaque coach affiche : nom, bio, spécialités, tarifs
  
  # Étape 4: Filtrage et détail
  When l'utilisateur filtre par pays "France"
  Then seuls les coachs français sont affichés  
  When l'utilisateur clique sur "Jean Dupont"
  Then l'écran détail coach s'affiche
  And affiche la bio complète, spécialités, certifications, tarifs
  And le bouton "Réserver" est visible et actif
```

#### Variantes de Recherche
```gherkin
Scenario: Aucun coach trouvé avec filtres
  When l'utilisateur filtre par pays "Antarctique"  
  Then le message "Aucun coach trouvé" est affiché
  And le bouton "Réinitialiser filtres" est proposé

Scenario: Pagination de la liste  
  Given il y a plus de 20 coachs disponibles
  When l'utilisateur fait défiler jusqu'en bas
  Then la page 2 se charge automatiquement (infinite scroll)
  And au moins 20 nouveaux coachs apparaissent

Scenario: Navigation retour depuis détail
  When l'utilisateur est sur le détail d'un coach
  And appuie sur le bouton retour
  Then il revient à la liste avec les filtres maintenus
```

#### Tests Performance Journey 2
- ⏱️ **Liste coachs loading** : < 3 secondes initial
- ⏱️ **Filtrage temps réel** : < 500ms response  
- ⏱️ **Détail coach** : < 2 secondes chargement
- 📱 **Scroll performance** : 60fps sur liste 100+ items

---

## 📅 JOURNEY 3: Processus de Réservation Complet

### US-006 + US-007 + US-009: Du booking à la confirmation

#### Happy Path Principal
```gherkin
Feature: Processus de Réservation Complet

Background:
  Given un client "alice@example.com" est connecté
  And un coach "jean@example.com" a des créneaux disponibles
  And le coach a configuré ses tarifs et disponibilités

Scenario: Réservation réussie avec paiement
  # Étape 1: Sélection coach et créneau  
  When le client recherche des coachs
  And sélectionne "Jean Dupont - Expert Fitness"
  And clique sur "Réserver"
  Then l'écran "Nouvelle Réservation" s'affiche
  
  # Étape 2: Configuration booking  
  When le client sélectionne la date "Demain"
  And sélectionne l'heure "14:00-15:00"
  And choisit la durée "60 minutes"
  And sélectionne le tarif "Regular - 50€"
  And saisit le message "Première séance, je débute en musculation"
  And appuie sur "Confirmer Réservation"
  
  Then la réservation est créée avec statut "En attente"
  And le client voit "Réservation envoyée au coach" 
  And le client reçoit l'ID de réservation
  
  # Étape 3: Coach traite la demande
  When le coach se connecte
  Then il voit 1 nouvelle réservation en attente
  And voit les détails : client, date, heure, message
  When le coach clique sur "Confirmer"
  Then le statut devient "Confirmée"
  
  # Étape 4: Séance réalisée et paiement  
  When la séance est terminée
  And le coach marque la séance comme "Terminée"  
  And le coach enregistre le paiement :
    | Montant | 50       |
    | Devise  | EUR      |  
    | Méthode | Espèces  |
    | Ref     | CASH-001 |
  
  Then le paiement apparaît dans l'historique
  And le statut final est "Payée et Terminée"
  And les statistiques coach sont mises à jour
```

#### Variantes Business Logic
```gherkin
Scenario: Conflict de créneau
  Given le créneau "14:00-15:00 demain" est déjà réservé
  When le client tente de réserver ce créneau  
  Then le message "Créneau non disponible" s'affiche
  And les créneaux alternatifs sont proposés

Scenario: Coach refuse la réservation
  When le coach sélectionne "Refuser"  
  And choisit la raison "Créneau non compatible"
  And ajoute le message "Proposons un autre horaire"
  Then le statut devient "Refusée"
  And le client reçoit la notification de refus avec raison

Scenario: No-show client
  When la séance était prévue mais le client n'est pas venu
  And le coach marque "No-show client"
  Then le statut devient "No-show"  
  And le coach peut facturer selon sa politique
```

#### Tests Performance Journey 3  
- ⏱️ **Booking creation** : < 2 secondes API response
- ⏱️ **Coach notification** : temps réel (< 5 secondes)
- ⏱️ **Payment recording** : < 1 seconde persistence
- 🔒 **Data consistency** : Pas de double-booking possible

---

## 🔐 JOURNEY 4: Cycles d'Authentification

### US-003: Login/Logout robuste cross-platform

#### Tests de Stress Authentification
```gherkin
Feature: Authentification Robuste

Scenario: Cycles login/logout multiples
  When l'utilisateur se connecte comme coach
  And navigue vers le profil  
  And se déconnecte
  And se reconnecte immédiatement
  And navigue vers les réservations
  And se déconnecte à nouveau
  Then chaque cycle fonctionne sans dégradation
  And aucune fuite mémoire n'est détectée
  And les données utilisateur sont correctement clearées

Scenario: Token expiry handling
  Given l'utilisateur est connecté depuis 24h
  When le token API expire
  And l'utilisateur tente une action (ex: voir profil)  
  Then l'utilisateur est automatiquement déconnecté
  And redirigé vers l'écran login
  And aucune data corrompue ou crash

Scenario: Connexion simultanée multiple devices
  Given l'utilisateur est connecté sur mobile  
  When il se connecte sur tablette avec même compte
  Then les deux sessions coexistent correctement
  And les données sont synchronisées en temps réel
  And pas de conflict de session
```

#### Tests Network Resilience
```gherkin
Scenario: Login avec réseau intermittent  
  When l'utilisateur saisit ses identifiants
  And le réseau se déconnecte pendant l'API call
  Then le message "Problème réseau, retry?" s'affiche
  When le réseau revient et l'utilisateur retry
  Then le login se complete normalement

Scenario: Offline behavior
  Given l'utilisateur était connecté  
  When le réseau devient indisponible
  Then l'app fonctionne en mode dégradé
  And affiche les données en cache
  And indique clairement le statut offline
```

---

## ⚡ JOURNEY 5: Performance & Memory

### Tests de Performance sur Parcours Longs

#### Memory Leak Detection
```gherkin
Feature: Performance et Memory Management

Scenario: Navigation intensive sans memory leak
  When l'utilisateur effectue 50 cycles complets :
    | Action                    | Répétitions |
    | Login → Dashboard         | 10          |  
    | Dashboard → Profil        | 10          |
    | Profil → Réservations     | 10          |
    | Réservations → Clients    | 10          |
    | Clients → Dashboard       | 10          |
  
  Then la mémoire utilisée reste < 300MB constamment
  And aucune augmentation > 10MB par cycle
  And le garbage collector fonctionne correctement

Scenario: Liste longue scroll performance
  Given une liste de 500+ coachs est chargée
  When l'utilisateur scroll rapidement haut/bas
  Then le framerate reste > 55 FPS constant  
  And pas de lag ou freeze UI
  And les images se chargent de façon lazy

Scenario: Background/Foreground cycles  
  When l'app passe en background  
  And revient au foreground après 30 minutes
  Then l'état UI est préservé correctement
  And pas de reload complet nécessaire
  And les données sensibles sont sécurisées
```

#### Cold Start Optimization
```gherkin
Scenario: Cold start performance
  Given l'app n'est pas en mémoire (force close)
  When l'utilisateur lance l'app
  Then splash screen s'affiche immédiatement
  And écran login est accessible en < 3 secondes
  And aucun freeze ou écran blanc prolongé

Scenario: Hot restart development
  Given l'app est en développement
  When hot restart est déclenché  
  Then l'app redémarre en < 1 seconde
  And l'état utilisateur est préservé  
  And pas de regression performance
```

---

## 📱 JOURNEY 6: Cross-Platform Specifics

### Android Behaviors
```gherkin
Feature: Android Platform Specifics

Scenario: Android back button navigation
  When l'utilisateur navigue : Login → Dashboard → Profil → Réservations
  And appuie 3 fois sur le bouton back Android
  Then il revient : Réservations → Profil → Dashboard
  And peut encore retourner au Login avec back final
  And pas de double-back exit accidentel

Scenario: Android keyboard behavior  
  When l'utilisateur focus un champ texte
  Then le soft keyboard s'affiche sans cacher le champ
  And le scroll automatique fonctionne
  And Done/Next buttons naviguent correctement
  And keyboard dismiss n'interfère pas avec validation

Scenario: Android permissions
  When l'app demande permission caméra (upload photo profil)  
  Then la dialog native Android s'affiche
  And Allow/Deny sont gérés gracieusement
  And pas de crash si permission refusée
```

### iOS Behaviors  
```gherkin
Feature: iOS Platform Specifics

Scenario: iOS swipe back navigation
  When l'utilisateur navigue vers écran détail
  And utilise swipe gesture pour revenir  
  Then la navigation back fonctionne naturellement
  And l'animation est fluide et native
  And état de l'écran parent est préservé

Scenario: iOS safe areas (iPhone avec notch)
  Given l'app tourne sur iPhone avec notch
  Then le contenu respecte les safe areas
  And pas de chevauchement avec notch/indicateur home  
  And le design reste esthétique et fonctionnel

Scenario: iOS dark/light mode transition
  When l'utilisateur switch entre light et dark mode (settings iOS)
  Then l'app s'adapte immédiatement au nouveau thème  
  And tous les écrans sont cohérents visuellement
  And pas de crash ou glitch pendant transition
```

---

## 🔗 JOURNEY 7: API Integration Robustness

### Backend Failure Scenarios
```gherkin
Feature: API Integration Resilience

Scenario: Backend API lent (> 5 secondes)
  Given le backend répond très lentement
  When l'utilisateur fait une action nécessitant API call
  Then un loading indicator s'affiche immédiatement  
  And après 5 secondes, option "Retry" apparaît
  And après 10 secondes, timeout avec message d'erreur
  And l'utilisateur peut retry ou annuler

Scenario: Backend retourne HTTP 500
  When une API call retourne erreur serveur 500
  Then le message "Service temporairement indisponible" s'affiche
  And l'utilisateur peut retry après quelques secondes
  And pas de crash ou état corrompu de l'app

Scenario: Backend retourne données malformées  
  When l'API retourne JSON invalide ou incomplete
  Then l'app utilise des données par défaut gracieusement
  And log l'erreur pour debugging (non visible user)
  And continue de fonctionner sans crash
```

---

## 📊 MÉTRIQUES SUCCESS PAR JOURNEY

### Journey Performance SLAs

| Journey | Cold Load | Navigation | Memory Peak | Success Rate |
|---------|-----------|------------|-------------|--------------|
| Coach Onboarding | < 5s | < 2s/step | < 250MB | 100% |
| Client Discovery | < 3s | < 1s/filter | < 200MB | 99.5% |  
| Booking Process | < 4s | < 2s/step | < 180MB | 99.9% |
| Auth Cycles | < 2s | < 1s | < 150MB | 100% |
| Performance Test | N/A | 60fps | < 300MB | 95% |
| Cross-Platform | < 3s | Native | < 200MB | 98% |
| API Resilience | < 5s | Retry logic | < 200MB | 90% |

### Critical Path Monitoring
- 🔥 **Authentication** : 0% failure rate acceptable
- 🔥 **Booking Creation** : 0% data loss acceptable  
- 🔥 **Coach Discovery** : < 1% empty results acceptable
- 🔥 **Payment Recording** : 0% data corruption acceptable
- ⚠️ **Performance** : < 5% performance degradation acceptable
- ⚠️ **Network Errors** : < 10% retry scenarios acceptable

---

## 🛠️ TOOLS & IMPLEMENTATION

### Gherkin Test Files Location
```
test/features/
├── coach_onboarding.feature      # Journey 1
├── client_discovery.feature      # Journey 2  
├── booking_process.feature       # Journey 3
├── authentication_cycles.feature # Journey 4
├── performance_memory.feature    # Journey 5
├── android_specifics.feature     # Journey 6a
├── ios_specifics.feature         # Journey 6b
└── api_resilience.feature        # Journey 7
```

### Step Definitions Implementation
```
test/step_definitions/
├── authentication_steps.dart     # Login/logout/signup steps
├── navigation_steps.dart         # Screen transitions, navigation  
├── form_interaction_steps.dart   # Input fields, buttons, validation
├── coach_management_steps.dart   # Coach-specific actions
├── client_actions_steps.dart     # Client-specific actions
├── booking_steps.dart            # Booking creation, management
├── api_mocking_steps.dart        # Mock API responses
├── performance_steps.dart        # Memory, timing assertions
└── common_steps.dart             # Shared reusable steps
```

### Automation Commands
```bash
# Run all user journey tests
flutter test test/features/ --reporter=json

# Run specific journey  
flutter test test/features/booking_process.feature

# Performance benchmarking during journeys
flutter test test/features/ --profile --trace-systrace

# Cross-platform journey validation
flutter test test/features/ --device-id android  
flutter test test/features/ --device-id ios
```

---

**🎯 OBJECTIF :** Chaque user journey doit être validée automatiquement à 100% avant toute release. Les parcours critiques P0 sont des gates bloquants absolus.