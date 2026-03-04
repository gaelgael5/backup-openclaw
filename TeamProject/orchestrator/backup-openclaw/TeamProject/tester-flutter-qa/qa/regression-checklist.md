# Checklist Régression MyCoach - Prevention Crashs

## 🚨 SMOKE TESTS CRITIQUES (Blocants Release)
**Temps d'exécution : < 5 minutes | Échec = STOP RELEASE**

### Pre-Release Gates (Automatisés CI/CD)
- [ ] **App Cold Start** : Démarre en < 3s sans crash
- [ ] **App Hot Restart** : Redémarre en < 1s sans memory leak  
- [ ] **Network Offline** : App fonctionne en mode dégradé sans crash
- [ ] **Auth Token Expired** : Logout automatique propre, pas de crash

### Authentication Flow Critiques  
- [ ] **Signup Coach** : Formulaire complet → email validation → profil créé
- [ ] **Signup Client** : Formulaire complet → email validation → recherche available  
- [ ] **Login Coach** : Credentials valides → dashboard coach accessible
- [ ] **Login Client** : Credentials valides → liste coachs accessible
- [ ] **Login Invalid** : Erreur claire, pas de crash, retry possible
- [ ] **Logout** : Clear session, retour écran login propre

### Core Business Logic
- [ ] **Recherche Coach** : Retourne minimum 1 résultat test, pas de liste vide
- [ ] **Booking Creation** : Crée réservation en statut 'pending' correctement
- [ ] **Booking Approval** : Coach peut confirmer réservation sans erreur
- [ ] **Payment Recording** : Enregistre paiement avec montant et devise
- [ ] **API Health** : Backend répond en < 500ms aux endpoints critiques

---

## 🔥 ZONES À RISQUES POST-CRASH

### 1. Authentication & Session Management
**Historique :** Crashes fréquents sur login/logout cycles

#### Tests Manuels Obligatoires
- [ ] **Login/Logout x3 cycles** : Pas de memory leak ou frozen UI
- [ ] **Token expiry handling** : Logout automatique sans crash
- [ ] **Concurrent logins** : Multiple devices, session handling correct
- [ ] **Network interruption mid-auth** : Retry mechanism fonctionne
- [ ] **Invalid token edge case** : API 401 → clean logout

#### Tests Automatisés Requis
```dart
testWidgets('Auth flow stress test', (tester) async {
  for (int i = 0; i < 5; i++) {
    // Login → navigate → logout → repeat
    await _performAuthCycle(tester);
    expect(find.text('Login'), findsOneWidget); // Clean state
  }
});
```

### 2. Navigation State Management  
**Historique :** Dead locks dans navigation stack

#### Tests Manuels Obligatoires
- [ ] **Deep navigation** : Login → profile → booking → payment → back x4
- [ ] **Tab switching** : Navigation rapide entre tabs sans freeze
- [ ] **Modal stacking** : Form modal → confirmation → error → back stack ok
- [ ] **Android back button** : Comportement prévisible, pas de crash
- [ ] **iOS swipe back** : Navigation propre sans état corrompu

#### Tests Automatisés Requis
```dart
testWidgets('Navigation stack integrity', (tester) async {
  // Simulate complex navigation then verify stack
  await tester.pumpAndSettle();
  expect(find.byType(MaterialApp), findsOneWidget);
  // No duplicate routes, clean stack
});
```

### 3. Form Validation & Null Safety
**Historique :** Null pointer exceptions sur formulaires

#### Tests Manuels Obligatoires  
- [ ] **Empty form submission** : Messages erreur clairs, pas de crash
- [ ] **Partial form fill** : Validation progressive sans exception
- [ ] **Special characters** : émojis, accents, caractères spéciaux OK
- [ ] **Network fail mid-submit** : Form garde état, retry possible  
- [ ] **Concurrent form edits** : Racing conditions gérées

#### Cas Edge Cases Critiques
```dart
// Tests automatisés des null edge cases
testWidgets('Null safety validation', (tester) async {
  // Submit empty forms
  await tester.tap(find.text('Submit'));
  expect(find.text('Required field'), findsWidgets);
  
  // Invalid email formats  
  await tester.enterText(find.byKey(Key('email')), 'invalid@');
  await tester.tap(find.text('Submit'));
  expect(find.text('Invalid email'), findsOneWidget);
});
```

### 4. Date/Time Operations (Booking Logic)
**Historique :** Timezone bugs, date parsing crashes

#### Tests Manuels Obligatoires
- [ ] **Timezone changes** : Booking times cohérents après changement TZ
- [ ] **Edge dates** : 29 février, changement heure d'été, nouvelle année
- [ ] **Booking conflicts** : Double-réservation même slot = erreur claire
- [ ] **Past date booking** : Validation empêche booking dans le passé
- [ ] **Far future dates** : Booking 1 an+ dans futur fonctionne

#### Tests Automatisés Critiques
```dart
testWidgets('Booking edge cases', (tester) async {
  // Test timezone edge cases
  DateTime now = DateTime.now();
  DateTime pastDate = now.subtract(Duration(days: 1));
  
  await _selectDate(tester, pastDate);
  await tester.tap(find.text('Book'));
  expect(find.text('Cannot book past date'), findsOneWidget);
});
```

---

## 📱 REGRESSION PAR PLATEFORME

### Android Specific Tests
- [ ] **Back button behavior** : Respecte navigation stack Android
- [ ] **Permissions** : Camera, storage, network permissions OK
- [ ] **Memory constraints** : Pas de crash sur devices RAM limitée
- [ ] **Keyboard behavior** : Soft keyboard n'interfère pas avec forms
- [ ] **Activity lifecycle** : App survit aux pause/resume cycles

### iOS Specific Tests  
- [ ] **Swipe gestures** : Navigation swipe back fonctionne naturellement
- [ ] **Safe areas** : UI respecte notch et dynamic island
- [ ] **Dark mode** : Transition light/dark mode sans crash
- [ ] **Background modes** : App handle bien transitions background/foreground
- [ ] **Memory warnings** : Graceful handling des low memory events

---

## 🔗 API CONTRACT TESTING

### Backend FastAPI Integration
**Critical Endpoints Coverage**

#### Authentication Endpoints
- [ ] `POST /auth/signup` - Returns 201 + api_key ou 400 + error details
- [ ] `POST /auth/login` - Returns 200 + api_key ou 401 + error details  
- [ ] `DELETE /auth/logout` - Returns 204 ou 401 if invalid token

#### Core Business Endpoints
- [ ] `GET /coaches` - Returns paginated coach list avec specs + pricing
- [ ] `POST /bookings` - Returns 201 + booking_id ou 400 + conflicts  
- [ ] `PUT /bookings/{id}/approve` - Returns 200 ou 404/403 si invalid
- [ ] `POST /payments` - Returns 201 + payment_id ou 400 + validation

#### Error Handling Contracts
- [ ] **HTTP 500** : App affiche "Service unavailable" pas de crash
- [ ] **HTTP 429** : Rate limiting handled gracefully avec retry
- [ ] **HTTP timeout** : Network timeout → user-friendly error
- [ ] **Malformed JSON** : Invalid API response → fallback behavior

### API Performance SLA
- [ ] **Response times** : 95% des calls < 500ms
- [ ] **Concurrent users** : 50 users simultanés sans dégradation
- [ ] **Data consistency** : Booking conflicts détectés correctement

---

## 🎯 BUSINESS LOGIC REGRESSION

### User Stories P0 End-to-End
**Tests complets des parcours critiques**

#### US-001 + US-002: Inscription Complète
- [ ] **Coach signup flow** : Formulaire → validation email → profil création
- [ ] **Client signup flow** : Formulaire → validation email → recherche access  
- [ ] **Edge cases** : Email déjà pris, mot de passe faible, network failure

#### US-003: Authentication Flow  
- [ ] **Happy path** : Login → JWT token → API access avec X-API-Key
- [ ] **Error cases** : Wrong password, account not found, email non-validé
- [ ] **Session management** : Token expiry, refresh, concurrent sessions

#### US-004: Coach Profile Setup
- [ ] **Profile creation** : Bio, spécialités, pricing, policies sauvegardés
- [ ] **Profile updates** : Modifications persisted correctement
- [ ] **Validation** : Formats pricing, longueurs text, required fields

#### US-005 + US-006: Booking Flow  
- [ ] **Coach discovery** : Filtres fonctionnent, pagination OK
- [ ] **Booking creation** : Slot selection → message → confirmation
- [ ] **Conflict detection** : Double booking prevented côté API

#### US-007: Coach Booking Management
- [ ] **Booking approval** : Coach peut confirmer/refuser avec raisons
- [ ] **Status transitions** : pending → confirmed → done/cancelled workflow
- [ ] **Notifications** : Coach notified des nouvelles réservations

#### US-008: Client Management  
- [ ] **Client listing** : Coach voit ses clients par statut relation
- [ ] **Client details** : Historique bookings, payment status visible
- [ ] **Relationship status** : Active/inactive clients tracked correctement

#### US-009: Payment Tracking
- [ ] **Payment recording** : Montant, devise, méthode, référence sauvegardés
- [ ] **Payment history** : Chronologique par client accessible  
- [ ] **Payment validation** : Montants positifs, devises valides

---

## ⚡ PERFORMANCE REGRESSION

### Benchmarks Critiques
**Seuils acceptables pour non-régression**

#### Startup Performance  
- [ ] **Cold start** : < 3 secondes (Android), < 2 secondes (iOS)
- [ ] **Warm start** : < 1 seconde toutes plateformes
- [ ] **Hot reload** : < 500ms en development mode

#### Navigation Performance
- [ ] **Screen transitions** : < 300ms entre écrans
- [ ] **List scrolling** : 60fps maintained sur listes 100+ items
- [ ] **Form input lag** : < 100ms response time clavier

#### Memory Benchmarks
- [ ] **Memory baseline** : < 150MB sur app idle
- [ ] **Memory peak** : < 300MB lors de navigation intensive
- [ ] **Memory leaks** : Pas de croissance >10MB après auth cycles

#### Network Performance  
- [ ] **API latency** : 95% calls < 500ms
- [ ] **Retry behavior** : Max 3 retries avec backoff exponentiel
- [ ] **Offline resilience** : Cache local fonctionne sans network

---

## 📊 AUTOMATED REGRESSION PIPELINE

### CI/CD Integration Checklist

#### Pre-commit Hooks
- [ ] **Linting** : `flutter analyze` passe sans warnings
- [ ] **Formatting** : `dart format --dry-run` no changes needed
- [ ] **Unit tests** : Suite unitaire < 30s execution time

#### Pull Request Gates
- [ ] **Unit + Widget tests** : 100% suite passante
- [ ] **Coverage report** : Minimum 85% maintenu  
- [ ] **Integration tests** : Core user stories validées
- [ ] **Golden tests** : UI screenshots unchanged ou approved

#### Nightly Regression
- [ ] **Full E2E suite** : Android/iOS device farm execution
- [ ] **Performance benchmark** : Comparison avec baseline
- [ ] **API contract tests** : Backend staging validation
- [ ] **Security scan** : Dependencies + code analysis

#### Release Readiness  
- [ ] **Smoke tests** : 100% critical path validated
- [ ] **Performance** : No degradation >20% vs previous
- [ ] **Crash rate** : 0% on P0 user stories
- [ ] **Coverage** : >85% global, >90% business logic

---

## 🛠️ EXECUTION INSTRUCTIONS

### Daily Regression (Automated)
```bash
# Run critical smoke tests (< 5min)
flutter test test/smoke/ --reporter=json

# Performance benchmarks
flutter test test/benchmarks/ --reporter=json

# API health checks  
curl -f https://api-staging.mycoach.com/health
```

### Pre-Release (Manual + Automated)
```bash
# Complete regression suite
flutter test --coverage
flutter test integration_test/
flutter test --update-goldens  # Verify UI changes

# Platform specific
flutter test --device-id android
flutter test --device-id ios
```

### Post-Incident (After Crash Fix)
1. **Root cause analysis** : Identifier crash pattern
2. **Add regression test** : Cover le cas qui a crashé
3. **Stress test** : Repeat scenario x10 pour stability  
4. **Update checklist** : Ajouter point de validation permanent

---

## ✅ SIGN-OFF CRITERIA

### Release Approval Requirements
- [ ] **100% smoke tests** passent sur Android + iOS
- [ ] **0 critical bugs** ouverts (crash ou data loss)
- [ ] **Performance benchmarks** dans les seuils acceptables  
- [ ] **Manual regression** core flows validés par QA human
- [ ] **API contract tests** passent vs production backend

### Emergency Hotfix Criteria
- [ ] **Critical smoke tests** seulement (< 5min)
- [ ] **Specific fix validation** reproduit + fixed
- [ ] **No new regressions** détectées sur zone fix

### Post-Release Monitoring  
- [ ] **Crash rate < 0.1%** dans les 24h post-release
- [ ] **Performance baseline** maintenu vs pre-release
- [ ] **User feedback** monitoring actif première semaine

---

**🔥 IMPORTANT :** Cette checklist doit être mise à jour après chaque incident de production. Chaque crash découvert = nouveau point de validation permanent.