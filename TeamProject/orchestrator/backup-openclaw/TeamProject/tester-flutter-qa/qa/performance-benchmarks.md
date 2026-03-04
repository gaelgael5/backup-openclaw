# Performance Benchmarks MyCoach Flutter

## 🎯 Objectifs Performance

**Vision :** Application MyCoach doit offrir une expérience fluide 60fps sur devices Android/iOS entry-level tout en maintenant une consommation mémoire optimale et des temps de réponse rapides.

**Baseline Devices :**
- **Android :** Samsung Galaxy A32 (4GB RAM, Snapdragon 665)  
- **iOS :** iPhone SE 2022 (4GB RAM, A15 Bionic)
- **Web :** Chrome desktop (8GB RAM, CPU Intel Core i5)

---

## ⚡ MÉTRIQUES CRITIQUES

### 1. Startup Performance (Critical)
**Objectif :** Cold start rapide pour première impression utilisateur

| Métrique | Seuil Optimal | Seuil Acceptable | Seuil Échec |
|----------|---------------|------------------|-------------|
| **Cold Start (Android)** | < 2s | < 3s | > 4s |
| **Cold Start (iOS)** | < 1.5s | < 2.5s | > 3s |
| **Warm Start** | < 500ms | < 1s | > 1.5s |
| **Hot Reload (dev)** | < 300ms | < 500ms | > 1s |

#### Tests Automatisés
```dart
// test/benchmarks/startup_performance_test.dart
testWidgets('Cold start benchmark', (tester) async {
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  
  stopwatch.stop();
  final startupTime = stopwatch.elapsedMilliseconds;
  
  // Fail si > 3000ms sur Android, > 2500ms sur iOS
  final maxAllowed = Platform.isAndroid ? 3000 : 2500;
  expect(startupTime, lessThan(maxAllowed),
    reason: 'Cold start took ${startupTime}ms, max allowed ${maxAllowed}ms');
    
  // Log pour trending analysis
  print('BENCHMARK_STARTUP: ${startupTime}ms');
});
```

### 2. Navigation Performance (Critical)
**Objectif :** Transitions fluides entre écrans

| Métrique | Seuil Optimal | Seuil Acceptable | Seuil Échec |
|----------|---------------|------------------|-------------|
| **Screen Transition** | < 200ms | < 300ms | > 500ms |
| **Form Validation** | < 50ms | < 100ms | > 200ms |
| **List Scroll (60fps)** | > 58fps | > 55fps | < 50fps |
| **Search Filtering** | < 100ms | < 250ms | > 500ms |

#### Tests Automatisés
```dart
// test/benchmarks/navigation_performance_test.dart  
testWidgets('Screen transition benchmark', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  
  // Login to get to dashboard
  await _performLogin(tester);
  
  final stopwatch = Stopwatch()..start();
  
  // Navigate to profile screen
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
  
  stopwatch.stop();
  final transitionTime = stopwatch.elapsedMilliseconds;
  
  expect(transitionTime, lessThan(300),
    reason: 'Screen transition took ${transitionTime}ms');
  print('BENCHMARK_NAVIGATION: ${transitionTime}ms');
});

testWidgets('List scroll performance', (tester) async {
  // Generate list of 100+ coaches for scroll test
  await _loadLargeCoachList(tester);
  
  final stopwatch = Stopwatch()..start();
  int frameCount = 0;
  
  // Simulate fast scroll
  await tester.fling(find.byType(ListView), Offset(0, -500), 1000);
  
  // Measure frame rate during scroll animation
  await tester.pump(Duration(milliseconds: 16)); // 60fps = 16ms per frame
  
  while (tester.binding.transientCallbackCount > 0) {
    await tester.pump(Duration(milliseconds: 16));
    frameCount++;
  }
  
  stopwatch.stop();
  final avgFrameTime = stopwatch.elapsedMilliseconds / frameCount;
  final fps = 1000 / avgFrameTime;
  
  expect(fps, greaterThan(55), reason: 'Scroll FPS was ${fps.toStringAsFixed(1)}');
  print('BENCHMARK_SCROLL_FPS: ${fps.toStringAsFixed(1)}');
});
```

### 3. Memory Management (Critical)
**Objectif :** Pas de memory leaks, usage optimisé

| Métrique | Seuil Optimal | Seuil Acceptable | Seuil Échec |
|----------|---------------|------------------|-------------|
| **Baseline Memory** | < 100MB | < 150MB | > 200MB |
| **Peak Memory Usage** | < 200MB | < 300MB | > 400MB |
| **Memory Leak/Hour** | 0MB | < 5MB | > 10MB |
| **GC Frequency** | < 5/min | < 10/min | > 15/min |

#### Tests Automatisés
```dart
// test/benchmarks/memory_benchmark_test.dart
testWidgets('Memory leak detection', (tester) async {
  final ProcessInfo processInfo = ProcessInfo();
  final initialMemory = processInfo.currentRss;
  
  // Perform 20 navigation cycles  
  for (int i = 0; i < 20; i++) {
    await _performCompletNavigationCycle(tester);
    
    // Force garbage collection
    gc();
    await tester.pump(Duration(milliseconds: 100));
    
    final currentMemory = processInfo.currentRss;
    final memoryIncrease = currentMemory - initialMemory;
    
    // Log memory usage for trending
    print('BENCHMARK_MEMORY_CYCLE_$i: ${currentMemory}MB (+${memoryIncrease}MB)');
  }
  
  final finalMemory = processInfo.currentRss;
  final totalLeak = finalMemory - initialMemory;
  
  expect(totalLeak, lessThan(50), // < 50MB growth after 20 cycles
    reason: 'Memory leak detected: ${totalLeak}MB growth');
});

Future<void> _performCompletNavigationCycle(WidgetTester tester) async {
  // Login → Dashboard → Profile → Bookings → Clients → Logout → Login
  await _performLogin(tester);
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Bookings'));
  await tester.pumpAndSettle(); 
  await tester.tap(find.text('Clients'));
  await tester.pumpAndSettle();
  await _performLogout(tester);
}
```

### 4. Network Performance (High Priority)
**Objectif :** API calls rapides, gestion timeouts

| Métrique | Seuil Optimal | Seuil Acceptable | Seuil Échec |
|----------|---------------|------------------|-------------|
| **API Response Time** | < 200ms | < 500ms | > 1000ms |
| **Image Load Time** | < 500ms | < 1s | > 2s |
| **Offline Resilience** | 100% | 95% | < 90% |
| **Retry Success Rate** | > 90% | > 80% | < 70% |

#### Tests Automatisés
```dart
// test/benchmarks/network_performance_test.dart
testWidgets('API response time benchmark', (tester) async {
  final httpClient = HttpClient();
  final stopwatch = Stopwatch();
  
  const endpoints = [
    '/auth/login',
    '/coaches',
    '/bookings',
    '/payments'
  ];
  
  for (final endpoint in endpoints) {
    stopwatch.reset();
    stopwatch.start();
    
    final response = await httpClient.get('https://api.mycoach.com$endpoint');
    
    stopwatch.stop();
    final responseTime = stopwatch.elapsedMilliseconds;
    
    expect(response.statusCode, equals(200));
    expect(responseTime, lessThan(500),
      reason: '$endpoint took ${responseTime}ms');
      
    print('BENCHMARK_API_${endpoint.replaceAll('/', '_')}: ${responseTime}ms');
  }
});

testWidgets('Network timeout handling', (tester) async {
  // Simulate slow network (3s delay)
  final mockClient = MockHttpClient();
  when(mockClient.get(any)).thenAnswer((_) => 
    Future.delayed(Duration(seconds: 3), () => mockResponse));
  
  await tester.pumpWidget(MyApp());
  
  // Try to load coach list
  await tester.tap(find.text('Search Coaches'));
  
  // Should show loading indicator
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  // After timeout, should show retry option
  await tester.pump(Duration(seconds: 5));
  expect(find.text('Retry'), findsOneWidget);
  
  print('BENCHMARK_TIMEOUT_HANDLING: PASSED');
});
```

---

## 🏗️ BENCHMARKS PAR COMPOSANT

### Authentication Flow Performance
```dart
// test/benchmarks/auth_performance_test.dart
group('Authentication Benchmarks', () {
  testWidgets('Login response time', (tester) async {
    final stopwatch = Stopwatch()..start();
    
    await tester.pumpWidget(MyApp());
    await tester.enterText(find.byKey(Key('email')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password')), 'password123');
    await tester.tap(find.text('Login'));
    
    // Wait for navigation to dashboard
    await tester.pumpUntil(find.text('Dashboard'), timeout: Duration(seconds: 5));
    
    stopwatch.stop();
    final loginTime = stopwatch.elapsedMilliseconds;
    
    expect(loginTime, lessThan(3000)); // Login flow < 3s
    print('BENCHMARK_LOGIN_FLOW: ${loginTime}ms');
  });
  
  testWidgets('Token refresh performance', (tester) async {
    // Test automatic token refresh doesn't cause UI freeze
    // ... implementation
  });
});
```

### Coach Discovery Performance  
```dart
// test/benchmarks/coach_discovery_performance_test.dart
group('Coach Discovery Benchmarks', () {
  testWidgets('Coach list initial load', (tester) async {
    final stopwatch = Stopwatch()..start();
    
    await _navigateToCoachList(tester);
    
    // Wait for coaches to load
    await tester.pumpUntil(find.byType(CoachCard), timeout: Duration(seconds: 5));
    
    stopwatch.stop();
    final loadTime = stopwatch.elapsedMilliseconds;
    
    expect(loadTime, lessThan(2000)); // Coach list < 2s
    print('BENCHMARK_COACH_LIST_LOAD: ${loadTime}ms');
  });
  
  testWidgets('Real-time search filtering', (tester) async {
    await _loadCoachList(tester);
    
    final stopwatch = Stopwatch()..start();
    
    // Type in search field
    await tester.enterText(find.byKey(Key('search')), 'fitness');
    
    // Wait for filtered results  
    await tester.pumpAndSettle();
    
    stopwatch.stop();
    final filterTime = stopwatch.elapsedMilliseconds;
    
    expect(filterTime, lessThan(250)); // Search filter < 250ms
    print('BENCHMARK_SEARCH_FILTER: ${filterTime}ms');
  });
});
```

### Booking Flow Performance
```dart
// test/benchmarks/booking_performance_test.dart  
group('Booking Flow Benchmarks', () {
  testWidgets('Booking creation end-to-end', (tester) async {
    final stopwatch = Stopwatch()..start();
    
    await _navigateToCoachDetail(tester);
    await tester.tap(find.text('Book'));
    await _selectBookingSlot(tester);
    await tester.tap(find.text('Confirm Booking'));
    
    // Wait for booking confirmation
    await tester.pumpUntil(find.text('Booking created'), timeout: Duration(seconds: 5));
    
    stopwatch.stop();
    final bookingTime = stopwatch.elapsedMilliseconds;
    
    expect(bookingTime, lessThan(4000)); // Booking flow < 4s  
    print('BENCHMARK_BOOKING_CREATION: ${bookingTime}ms');
  });
  
  testWidgets('Calendar availability loading', (tester) async {
    final stopwatch = Stopwatch()..start();
    
    await tester.tap(find.text('Book'));
    
    // Wait for calendar to show available slots
    await tester.pumpUntil(find.byType(CalendarWidget), timeout: Duration(seconds: 3));
    
    stopwatch.stop();
    final calendarTime = stopwatch.elapsedMilliseconds;
    
    expect(calendarTime, lessThan(1500)); // Calendar < 1.5s
    print('BENCHMARK_CALENDAR_LOAD: ${calendarTime}ms');
  });
});
```

---

## 📊 CONTINUOUS MONITORING

### Performance Tracking Pipeline
```bash
#!/bin/bash
# scripts/run_performance_benchmarks.sh

echo "=== MyCoach Performance Benchmark Suite ==="
date

# Run all benchmark tests
flutter test test/benchmarks/ --reporter=json > benchmark_results.json

# Extract metrics for trending
grep "BENCHMARK_" benchmark_results.json | while read line; do
  echo "$line" >> performance_history.log
done

# Generate performance report
python scripts/generate_performance_report.py

# Check for regressions (fail CI if > 20% degradation)
python scripts/check_performance_regression.py --threshold=0.20
```

### Performance History Tracking
```python
# scripts/performance_tracking.py
import json
import sqlite3
from datetime import datetime

def store_benchmark_result(metric_name, value, timestamp):
    """Store benchmark result in SQLite for trending analysis"""
    conn = sqlite3.connect('performance_history.db')
    cursor = conn.cursor()
    
    cursor.execute('''
        INSERT INTO benchmarks (metric, value, timestamp, commit_hash)
        VALUES (?, ?, ?, ?)
    ''', (metric_name, value, timestamp, get_git_commit()))
    
    conn.commit()
    conn.close()

def check_regression(metric_name, current_value, days_back=7):
    """Check if current performance is significantly worse than baseline"""
    conn = sqlite3.connect('performance_history.db')
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT AVG(value) FROM benchmarks 
        WHERE metric = ? AND timestamp > datetime('now', '-{} days')
    '''.format(days_back), (metric_name,))
    
    baseline = cursor.fetchone()[0]
    degradation = (current_value - baseline) / baseline
    
    if degradation > 0.20:  # 20% regression threshold
        raise Exception(f"Performance regression detected: {metric_name} "
                       f"degraded by {degradation*100:.1f}%")
```

### Alert Thresholds (CI/CD)
```yaml
# .github/workflows/performance_monitoring.yml
name: Performance Monitoring

on:
  push:
    branches: [main, develop]
  schedule:
    - cron: '0 2 * * *'  # Nightly at 2 AM

jobs:
  performance_tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v1
        with:
          flutter-version: '3.x'
      
      - name: Run Performance Benchmarks  
        run: |
          flutter test test/benchmarks/ --reporter=json
          
      - name: Check Performance Regression
        run: |
          python scripts/check_performance_regression.py
          
      - name: Create Performance Report
        if: failure()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: 'Performance Regression Detected',
              body: 'Automated performance tests detected significant degradation. See logs for details.',
              labels: ['performance', 'regression', 'priority-high']
            });
```

---

## 🎯 DEVICE SPECIFIC BENCHMARKS

### Android Performance Matrix
```dart
// test/benchmarks/android_performance_test.dart
testWidgets('Android device performance matrix', (tester) async {
  final deviceInfo = await DeviceInfoPlugin().androidInfo;
  final deviceSpecs = {
    'model': deviceInfo.model,
    'ram': _getDeviceRAM(),
    'android_version': deviceInfo.version.release,
  };
  
  // Adjust performance expectations based on device specs
  int startupThreshold = 3000; // Default
  if (deviceSpecs['ram'] < 4) startupThreshold = 4000; // Low-end device
  if (deviceSpecs['ram'] > 6) startupThreshold = 2000;  // High-end device
  
  final stopwatch = Stopwatch()..start();
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(startupThreshold));
  
  print('BENCHMARK_ANDROID_${deviceSpecs['model']}: ${stopwatch.elapsedMilliseconds}ms');
});
```

### iOS Performance Matrix  
```dart
// test/benchmarks/ios_performance_test.dart
testWidgets('iOS device performance matrix', (tester) async {
  final deviceInfo = await DeviceInfoPlugin().iosInfo;
  final deviceSpecs = {
    'model': deviceInfo.model,
    'ios_version': deviceInfo.systemVersion,
  };
  
  // iOS generally faster, adjust thresholds
  int startupThreshold = 2500;
  if (deviceInfo.model.contains('SE')) startupThreshold = 3000; // SE is lower spec
  
  final stopwatch = Stopwatch()..start();
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(startupThreshold));
  
  print('BENCHMARK_IOS_${deviceSpecs['model']}: ${stopwatch.elapsedMilliseconds}ms');
});
```

### Web Performance (Flutter Web)
```dart
// test/benchmarks/web_performance_test.dart
testWidgets('Flutter web performance', (tester) async {
  // Web-specific performance considerations
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  
  stopwatch.stop();
  
  // Web startup typically slower, adjust threshold
  expect(stopwatch.elapsedMilliseconds, lessThan(5000));
  
  print('BENCHMARK_WEB_STARTUP: ${stopwatch.elapsedMilliseconds}ms');
});
```

---

## 🚀 OPTIMIZATION TARGETS

### Short Term (Current Sprint)
- ✅ **Cold start < 3s** sur Android entry-level
- ✅ **Navigation < 300ms** entre tous les écrans P0
- ✅ **Memory baseline < 150MB** en idle
- ✅ **API responses < 500ms** pour 95% des calls

### Medium Term (Next 2 Months)  
- 🎯 **Cold start < 2s** sur Android mid-range
- 🎯 **60fps constant** sur listes 200+ items
- 🎯 **Memory peak < 250MB** même avec usage intensif
- 🎯 **Offline mode** fonctionnel avec cache intelligent

### Long Term (6+ Months)
- 🚀 **Sub-second startup** sur toutes plateformes
- 🚀 **Predictive loading** des données utilisateur
- 🚀 **Background sync** optimisé pour battery life
- 🚀 **Performance analytics** intégrées pour monitoring

---

## 📈 REPORTING & METRICS DASHBOARD

### Daily Performance Report
```python
# scripts/daily_performance_report.py
def generate_daily_report():
    """Generate daily performance summary"""
    metrics = load_latest_benchmarks()
    
    report = f"""
    ## MyCoach Performance Report - {datetime.now().strftime('%Y-%m-%d')}
    
    ### Startup Performance
    - Cold Start (Android): {metrics['startup_android']}ms ({'✅' if metrics['startup_android'] < 3000 else '❌'})
    - Cold Start (iOS): {metrics['startup_ios']}ms ({'✅' if metrics['startup_ios'] < 2500 else '❌'})
    
    ### Memory Usage  
    - Baseline: {metrics['memory_baseline']}MB ({'✅' if metrics['memory_baseline'] < 150 else '❌'})
    - Peak Usage: {metrics['memory_peak']}MB ({'✅' if metrics['memory_peak'] < 300 else '❌'})
    
    ### Network Performance
    - API Average: {metrics['api_avg']}ms ({'✅' if metrics['api_avg'] < 500 else '❌'})
    - P95 Response: {metrics['api_p95']}ms ({'✅' if metrics['api_p95'] < 1000 else '❌'})
    
    ### Trend Analysis
    - Performance vs Last Week: {calculate_trend(metrics, days=7)}
    - Regression Alerts: {count_regressions(metrics)}
    """
    
    # Send to Slack/Discord if configured
    send_notification(report)
```

### Performance Dashboard Metrics
```json
{
  "dashboard_metrics": {
    "startup": {
      "android_cold": {"current": 2800, "trend": "+5%", "status": "warning"},
      "ios_cold": {"current": 1900, "trend": "-2%", "status": "good"},
      "warm_start": {"current": 800, "trend": "0%", "status": "good"}
    },
    "navigation": {
      "screen_transition": {"current": 250, "trend": "+10%", "status": "warning"},
      "form_validation": {"current": 80, "trend": "-5%", "status": "good"}  
    },
    "memory": {
      "baseline": {"current": 140, "trend": "+2%", "status": "good"},
      "peak": {"current": 280, "trend": "+8%", "status": "warning"},
      "leaks": {"current": 0, "trend": "0%", "status": "good"}
    },
    "network": {
      "api_p50": {"current": 320, "trend": "-3%", "status": "good"},
      "api_p95": {"current": 750, "trend": "+12%", "status": "warning"},
      "timeout_rate": {"current": 0.5, "trend": "+0.2%", "status": "good"}
    }
  }
}
```

---

## ⚡ EXECUTION COMMANDS

### Local Performance Testing
```bash
# Run complete benchmark suite  
flutter test test/benchmarks/ --reporter=json | tee benchmark_results.json

# Run specific performance category
flutter test test/benchmarks/startup_performance_test.dart
flutter test test/benchmarks/memory_benchmark_test.dart  
flutter test test/benchmarks/network_performance_test.dart

# Profile mode for detailed analysis
flutter test test/benchmarks/ --profile --trace-systrace

# Generate performance report
python scripts/generate_performance_report.py benchmark_results.json
```

### CI/CD Performance Gates
```bash
# Pre-merge performance check (fast, < 2 min)
flutter test test/benchmarks/smoke_performance_test.dart --timeout=120s

# Nightly complete performance suite (comprehensive, ~15 min)  
flutter test test/benchmarks/ --concurrency=1 --timeout=900s

# Performance regression check
python scripts/check_performance_regression.py --threshold=0.15 --baseline=7d
```

---

**🚀 VISION :** MyCoach doit être perçue comme l'app la plus fluide de sa catégorie, capable de fonctionner parfaitement même sur devices entry-level. Performance = différenciateur concurrentiel.