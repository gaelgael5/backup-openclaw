# Stratégie de Tests MyCoach Flutter App

## 🎯 Vision QA

**Objectif :** Garantir la stabilité et la fiabilité de l'application MyCoach après les crashs récents corrigés. Focus sur les user stories P0 critiques et la prévention de régressions.

**Cibles :** Android + iOS, avec backend FastAPI

---

## 🏗️ Architecture de Tests

### Pyramide de Tests

```
                    E2E Tests (5%)
                   ↗ User Journeys ↖
              Integration Tests (15%)
             ↗ API + Widget Flows ↖
        Unit Tests (80%)
       ↗ Business Logic ↖
```

### Stack Technique

- **Framework :** Flutter/Dart
- **Tests unitaires :** `flutter_test` + `mockito`
- **Tests widget :** `flutter_test` + golden tests
- **Tests intégration :** `integration_test` package
- **BDD/Gherkin :** `bdd_widget_test` + `gherkin`
- **API Testing :** `http` package + contrats OpenAPI
- **Mocking :** `mockito` + `build_runner`
- **Coverage :** `lcov` (objectif 80%+ sur P0)

---

## 📱 Niveaux de Tests

### 1. Tests Unitaires (80%)
**Responsabilité :** Logique métier isolée

**Couverture obligatoire :**
- ✅ **Authentication logic** (login/signup validation)
- ✅ **Booking business rules** (slot calculation, conflicts)
- ✅ **Payment calculations** (tarifs, packages)
- ✅ **Data models** (User, Coach, Booking, Payment)
- ✅ **Repository layer** (API calls, caching)
- ✅ **State management** (Bloc/Cubit/Riverpod)

**Structure :**
```
test/unit/
├── models/                # User, Coach, Booking models
├── repositories/          # API repositories (mocked)
├── blocs/                # State management logic
├── services/             # Business services
└── validators/           # Form validation logic
```

**Règles :**
- Chaque classe métier = 1 fichier test
- Coverage minimum 90% sur business logic
- Mocks obligatoires pour toute dépendance externe
- Tests unitaires RAPIDES (< 10ms par test)

### 2. Tests Widget (15%)
**Responsabilité :** UI components en isolation

**Couverture obligatoire :**
- ✅ **Forms validation** (signup, login, booking)
- ✅ **State rendering** (loading, error, success states)
- ✅ **Navigation flows** (onboarding sequence)
- ✅ **Critical widgets** (CoachCard, BookingForm, PaymentForm)

**Structure :**
```
test/widget/
├── screens/              # Écrans complets
├── components/           # Widgets réutilisables
├── forms/               # Formulaires complexes
└── goldens/             # Golden tests (screenshots)
```

**Golden Tests :**
- Écrans P0 sur 3 résolutions : mobile (375px), tablet (768px), desktop (1440px)
- Mode sombre/clair
- États : loading, error, empty, success

### 3. Tests Intégration (15%)
**Responsabilité :** Parcours utilisateur complets

**User Stories P0 à tester :**
- ✅ **US-001:** Inscription coach complète
- ✅ **US-002:** Inscription client complète  
- ✅ **US-003:** Flow de connexion
- ✅ **US-004:** Configuration profil coach
- ✅ **US-005:** Recherche et sélection coach
- ✅ **US-006:** Processus de réservation
- ✅ **US-007:** Gestion réservations (coach)
- ✅ **US-008:** Navigation liste clients
- ✅ **US-009:** Enregistrement paiements

**Structure :**
```
test/integration/
├── user_journeys/        # Parcours complets P0
├── api_contracts/        # Tests contrats FastAPI
└── cross_platform/      # Android/iOS specific
```

### 4. Tests E2E (5%)
**Responsabilité :** Scenarios critiques end-to-end

**Scenarios prioritaires :**
- 🔥 **Happy path complet :** Signup coach → config profil → client trouve coach → réservation → confirmation → paiement
- 🔥 **Authentication flow :** Login/logout sur les 2 rôles
- 🔥 **Booking conflicts :** Éviter double-réservation même créneau

---

## 🧬 Tests Comportementaux (BDD)

### Gherkin Scenarios
Écriture des user stories P0 en Gherkin pour validation métier.

**Exemple US-006 (Réservation) :**
```gherkin
Feature: Réservation de séance

  Background:
    Given un client connecté "alice@test.com"
    And un coach "coach@test.com" avec créneaux disponibles
    
  Scenario: Réservation réussie
    When le client recherche des coachs
    And sélectionne le coach "John Doe"
    And choisit le créneau "14h-15h demain"
    And saisit le message "Première séance fitness"
    And confirme la réservation
    Then la réservation est créée en statut "pending"
    And le coach reçoit la demande
    And le client voit la réservation dans son planning

  Scenario: Créneau déjà pris
    Given le créneau "14h-15h demain" est déjà réservé
    When le client tente de réserver ce créneau
    Then le message "Créneau non disponible" s'affiche
    And aucune réservation n'est créée
```

### Step Definitions
Implementation Dart des steps Gherkin dans `test/step_definitions/`.

---

## 📊 Métriques et Coverage

### Objectifs Coverage
- **Unit tests :** 90%+ business logic
- **Widget tests :** 80%+ écrans P0
- **Integration tests :** 100% user stories P0
- **Overall :** 85%+ sur l'ensemble

### Métriques Qualité
- **Performance :** Frame drops < 5% sur parcours critiques
- **Memory :** Pas de memory leaks sur les flows longs
- **Startup time :** < 3s cold start, < 1s warm start
- **API response :** 95% calls < 500ms
- **Crash rate :** 0% sur user stories P0

### Rapports Automatisés
```bash
# Coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Performance benchmarks  
flutter test test/benchmarks/

# Golden tests verification
flutter test --update-goldens  # CI fails if drift
```

---

## 🔄 CI/CD Integration

### Pre-commit Hooks
- Linting (`flutter analyze`)
- Format check (`dart format --dry-run`)
- Unit tests rapides (< 30s)

### Pull Request Triggers
1. **Unit + Widget tests** (parallèle, ~2min)
2. **Integration tests** (séquentiel, ~5min)
3. **Coverage report** → commentaire PR
4. **Golden tests verification** → fail si drift

### Nightly Regression
- **Suite complète E2E** sur device farm (Android/iOS)
- **Performance benchmarks** avec trending
- **API contract testing** vs FastAPI staging
- **Security scan** (code + dependencies)

### Release Gates
- ✅ 100% tests P0 passent
- ✅ Coverage > 85%
- ✅ 0 critical bugs ouverts
- ✅ Performance benchmarks OK
- ✅ Golden tests à jour

---

## 🚨 Gestion Environnements

### Test Data Management
```dart
// Fixtures pour tests répétables
class TestUsers {
  static const validCoach = TestUser(
    email: "coach@test.example.com",  // Domaine .example.com !
    password: "ValidPass123!",
    role: "coach"
  );
  
  static const validClient = TestUser(
    email: "client@test.example.com", 
    password: "ValidPass123!",
    role: "client"
  );
}
```

### Environment Isolation
- **Unit tests :** Pas d'appels réseau (mocks only)
- **Widget tests :** UI pure, API mockée
- **Integration tests :** API staging dédiée testing
- **E2E tests :** Environment staging avec reset automatique

### Mock API Responses
```dart
// Mock standardisés pour les tests widget/unit
final mockAuthResponse = {
  "api_key": "test_key_12345",
  "user_id": "user_123",
  "role": "coach"
};

final mockCoachProfile = {
  "id": "coach_123",
  "name": "John Doe",
  "bio": "Expert fitness",
  "specialties": ["musculation", "fitness"],
  "default_rate": 50.0
};
```

---

## 🎯 Focus Anti-Régression

### Zones à Risque (Post-Crash)
- 🔥 **Authentication flow** (login/signup)
- 🔥 **State management** (navigation states)
- 🔥 **API error handling** (network failures)
- 🔥 **Form validation** (null safety)
- 🔥 **Date/time operations** (booking conflicts)

### Smoke Tests Critiques
Tests rapides (< 30s) bloquants pour toute release :
1. App démarre sans crash
2. Login coach réussit  
3. Login client réussit
4. Recherche coach retourne résultats
5. Création réservation aboutit

---

## 📋 Test Planning

### Planification Release
1. **Sprint début :** Review user stories → update test strategy
2. **Development :** Red-Green-Refactor TDD sur business logic
3. **Feature complete :** Integration tests des nouvelles features  
4. **Pre-release :** Regression suite complète + performance
5. **Post-release :** Monitor crash metrics vs regression tests

### Maintenance Continue  
- **Weekly :** Review flaky tests, update fixtures
- **Monthly :** Performance benchmarks trending
- **Quarterly :** Test strategy review vs business evolution

---

## ⚖️ Définitions

**Critical Bug :** Empêche une user story P0, cause crash ou perte de données  
**Major Bug :** Impacte UX d'une feature P0 mais workaround existe  
**Minor Bug :** Cosmétique ou edge case rare  

**Test Success :** Toutes assertions passent, pas d'exception, performance OK  
**Test Flaky :** Succès/échec intermittent → quarantine jusqu'à fix  

**Regression :** Feature précédemment fonctionnelle qui échoue post-changement