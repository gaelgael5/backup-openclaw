# MyCoach Design System - Spécifications Techniques

> **🎯 OBJECTIF :** Spécifications complètes pour développement Flutter production  
> **🔧 STACK :** Flutter 3.24+, Material 3, Custom Design System  
> **💾 BACKEND :** Compatible http://192.168.10.63:8000 (FastAPI)

---

## 🏗️ Architecture Technique

### Structure des fichiers

```
lib/
├── design_system/
│   ├── design_system.dart           # Core système
│   ├── components/
│   │   ├── glass_card.dart          # Composant glassmorphism
│   │   ├── glass_button.dart        # Boutons avec effets
│   │   ├── glass_container.dart     # Container générique
│   │   └── mycoach_textfield.dart   # Input fields
│   ├── theme/
│   │   ├── colors.dart              # Palettes de couleurs
│   │   ├── typography.dart          # Système typographique
│   │   ├── spacing.dart             # Grille de spacing
│   │   └── animations.dart          # Courbes et durées
│   └── screens/
│       ├── onboarding/              # Écrans d'onboarding
│       ├── auth/                    # Authentication
│       ├── coach/                   # Interface coach
│       └── client/                  # Interface client
├── models/
│   ├── user.dart                    # Modèle utilisateur
│   └── theme_state.dart             # État du thème
├── services/
│   ├── api_service.dart             # Communication backend
│   └── theme_service.dart           # Gestion thème persistant
└── utils/
    ├── constants.dart               # Constantes app
    └── helpers.dart                 # Fonctions utilitaires
```

---

## 🎨 Spécifications Visuelles

### Palette de Couleurs Exactes

#### Coach Theme (Dark Tech)
```dart
// Backgrounds (HSL pour précision)
backgroundPrimary:    HSL(240°, 33%, 6%)   // #0A0A0F
backgroundSecondary:  HSL(240°, 25%, 8%)   // #12121A  
backgroundTertiary:   HSL(240°, 20%, 12%)  // #1A1A24

// Accents
accentPrimary:   HSL(14°, 100%, 60%)   // #FF6B35 Electric Orange
accentSecondary: HSL(258°, 84%, 61%)   // #8B5CF6 Electric Purple  
accentTertiary:  HSL(152°, 100%, 52%)  // #06FFA5 Electric Cyan

// Text
textPrimary:   HSL(0°, 0%, 100%)       // #FFFFFF Pure White
textSecondary: HSL(240°, 14%, 71%)     // #B8B8CC Muted White
textTertiary:  HSL(240°, 8%, 43%)      // #6B6B7A Disabled
```

#### Client Theme (Light Dynamic)  
```dart
// Backgrounds
backgroundPrimary:   HSL(230°, 100%, 98%)  // #F8FAFF Ultra Light Blue
backgroundSecondary: HSL(0°, 0%, 100%)     // #FFFFFF Pure White
backgroundTertiary:  HSL(230°, 100%, 96%)  // #F0F4FF Light Blue Tint

// Accents  
accentPrimary:   HSL(194°, 100%, 50%)  // #00D2FF Electric Cyan
accentSecondary: HSL(331°, 100%, 63%)  // #FF4081 Electric Pink
accentTertiary:  HSL(248°, 69%, 66%)   // #7B68EE Electric Blue

// Text
textPrimary:   HSL(240°, 39%, 9%)      // #0F0F23 Deep Dark
textSecondary: HSL(240°, 13%, 31%)     // #4A4A5A Medium Gray  
textTertiary:  HSL(240°, 7%, 59%)      // #9090A0 Light Gray
```

### Typography Scale

```dart
// Coach Typography (Space Grotesk)
heroDisplay:  48px/56px, Weight 900, -2% letter-spacing
titleXL:      32px/40px, Weight 800, -1% letter-spacing
titleL:       24px/32px, Weight 700, -0.5% letter-spacing
titleM:       20px/28px, Weight 700, 0% letter-spacing
bodyL:        16px/24px, Weight 400, 0% letter-spacing
bodyM:        14px/20px, Weight 400, 0% letter-spacing
caption:      10px/12px, Weight 500, 1% letter-spacing

// Client Typography (plus light, légèrement plus petit)
heroDisplay:  44px/52px, Weight 800, -1.5% letter-spacing
titleXL:      28px/36px, Weight 700, -1% letter-spacing
// ... (voir design_system.dart pour détails complets)
```

### Glassmorphism Specifications

```dart
// Blur Levels (performance optimized)
Level 1: 40px blur  // Backgrounds
Level 2: 20px blur  // Cards standard
Level 3: 15px blur  // Buttons
Level 4: 10px blur  // Floating elements

// Opacity & Gradients
Coach Glass:
  - Gradient: rgba(255,255,255,0.08) → rgba(255,255,255,0.02)
  - Border: rgba(255,255,255,0.15)
  - Shadow: rgba(0,0,0,0.3)

Client Glass:
  - Gradient: rgba(255,255,255,0.5) → rgba(255,255,255,0.2)  
  - Border: rgba(0,210,255,0.2)
  - Shadow: rgba(0,210,255,0.15)
```

---

## ⚡ Performance Specifications

### Optimization Targets

```dart
// Performance Benchmarks
Frame Rate:       60 FPS constant
Startup Time:     < 3 seconds cold start  
Memory Usage:     < 150MB peak
Battery Impact:   Low (optimized animations)
Network:          Graceful offline handling
```

### Glassmorphism Performance

```dart
// Conditional blur based on device capability
class GlassOptimization {
  static int getOptimalBlurLevel(int requestedLevel) {
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    final isLowEndDevice = devicePixelRatio < 2.0;
    
    if (isLowEndDevice) {
      return math.max(1, requestedLevel - 1); // Reduce blur
    }
    return requestedLevel;
  }
  
  static bool shouldUseAdvancedEffects() {
    // Disable complex effects on low-end devices
    return !Platform.isAndroid || 
           WidgetsBinding.instance.window.devicePixelRatio >= 2.0;
  }
}
```

### Animation Performance

```dart
// Optimized animation curves (60fps)
static const Duration micro = Duration(milliseconds: 100);
static const Duration fast = Duration(milliseconds: 200);
static const Duration standard = Duration(milliseconds: 300);
static const Duration slow = Duration(milliseconds: 500);

// Hardware-accelerated curves
static const Cubic easeOutExpo = Cubic(0.19, 1, 0.22, 1);
static const Cubic easeInOutQuart = Cubic(0.77, 0, 0.175, 1);
```

---

## 🔌 Backend Integration

### API Configuration

```dart
// Service configuration pour http://192.168.10.63:8000
class ApiConfig {
  static const String baseUrl = 'http://192.168.10.63:8000';
  static const String apiVersion = '/api/v1';
  
  // Endpoints
  static const String auth = '$baseUrl$apiVersion/auth';
  static const String users = '$baseUrl$apiVersion/users';
  static const String workouts = '$baseUrl$apiVersion/workouts';
  static const String analytics = '$baseUrl$apiVersion/analytics';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Client-Version': '1.0.0',
    'X-Client-Platform': Platform.operatingSystem,
  };
}
```

### User Model Integration

```dart
class User {
  final String id;
  final String name;
  final String email;
  final UserType type; // COACH | CLIENT
  final ThemePreferences themePrefs;
  
  const User({
    required this.id,
    required this.name, 
    required this.email,
    required this.type,
    required this.themePrefs,
  });
  
  // Auto-configure theme based on user type
  void configureTheme() {
    MyCoachDesignSystem.setUserType(type == UserType.COACH);
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      type: UserType.values.firstWhere(
        (t) => t.name.toLowerCase() == json['user_type'].toLowerCase(),
      ),
      themePrefs: ThemePreferences.fromJson(json['theme_preferences'] ?? {}),
    );
  }
}

enum UserType { COACH, CLIENT }

class ThemePreferences {
  final bool isDarkMode;
  final String accentColor;
  final bool advancedEffects;
  
  const ThemePreferences({
    this.isDarkMode = false,
    this.accentColor = 'default',
    this.advancedEffects = true,
  });
  
  factory ThemePreferences.fromJson(Map<String, dynamic> json) {
    return ThemePreferences(
      isDarkMode: json['dark_mode'] ?? false,
      accentColor: json['accent_color'] ?? 'default',
      advancedEffects: json['advanced_effects'] ?? true,
    );
  }
}
```

### Authentication Flow

```dart
class AuthService {
  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/login'),
      headers: ApiConfig.headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final user = User.fromJson(userData['user']);
      
      // Auto-configure theme
      user.configureTheme();
      
      return user;
    }
    
    throw AuthException('Login failed');
  }
  
  static Future<User> register({
    required String name,
    required String email, 
    required String password,
    required UserType userType,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/register'),
      headers: ApiConfig.headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'user_type': userType.name.toLowerCase(),
      }),
    );
    
    if (response.statusCode == 201) {
      final userData = jsonDecode(response.body);
      final user = User.fromJson(userData['user']);
      user.configureTheme();
      return user;
    }
    
    throw AuthException('Registration failed');
  }
}
```

---

## 🎛️ State Management

### Theme State Management

```dart
// Provider-based theme management
class ThemeProvider extends ChangeNotifier {
  bool _isCoachTheme = true;
  bool _isDarkMode = false;
  User? _currentUser;
  
  bool get isCoachTheme => _isCoachTheme;
  bool get isDarkMode => _isDarkMode;
  User? get currentUser => _currentUser;
  
  void setUser(User user) {
    _currentUser = user;
    _isCoachTheme = user.type == UserType.COACH;
    _isDarkMode = user.themePrefs.isDarkMode;
    
    MyCoachDesignSystem.setUserType(_isCoachTheme);
    if (_isDarkMode) MyCoachDesignSystem.toggleDarkMode();
    
    notifyListeners();
  }
  
  void toggleUserType() {
    _isCoachTheme = !_isCoachTheme;
    MyCoachDesignSystem.setUserType(_isCoachTheme);
    notifyListeners();
  }
  
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    MyCoachDesignSystem.toggleDarkMode();
    notifyListeners();
  }
  
  ThemeData get currentTheme => MyCoachTheme.currentTheme;
}

// Usage in main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyCoachApp(),
    ),
  );
}

class MyCoachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'MyCoach',
          theme: themeProvider.currentTheme,
          home: OnboardingWelcomeScreen(),
        );
      },
    );
  }
}
```

---

## 📱 Device Support & Testing

### Supported Devices

```dart
// Minimum requirements
- iOS: 12.0+
- Android: API 21+ (Android 5.0)
- RAM: 2GB minimum, 4GB recommended
- Storage: 100MB for app + cache

// Tested devices
- iPhone: 12, 13, 14, SE (2022)
- Android: Pixel 6/7, Samsung Galaxy S21+, OnePlus 9
- Tablets: iPad Air, Samsung Galaxy Tab S8
```

### Screen Size Support

```dart
// Responsive breakpoints
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;
      
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < desktop;
      
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}

// Adaptive layouts
Widget buildAdaptiveLayout(BuildContext context) {
  if (Breakpoints.isMobile(context)) {
    return MobileLayout();
  } else if (Breakpoints.isTablet(context)) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

---

## 🔒 Security Specifications

### Secure Storage

```dart
// Store theme preferences securely
class SecurePreferences {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> setThemePreferences(ThemePreferences prefs) async {
    await _storage.write(
      key: 'theme_preferences',
      value: jsonEncode(prefs.toJson()),
    );
  }
  
  static Future<ThemePreferences?> getThemePreferences() async {
    final prefsJson = await _storage.read(key: 'theme_preferences');
    if (prefsJson != null) {
      return ThemePreferences.fromJson(jsonDecode(prefsJson));
    }
    return null;
  }
  
  static Future<void> setAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

### API Security

```dart
class SecureApiService {
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await SecurePreferences.getAuthToken();
    return {
      ...ApiConfig.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  static Future<http.Response> securePost(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final headers = await getAuthHeaders();
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }
  
  static Future<http.Response> secureGet(String endpoint) async {
    final headers = await getAuthHeaders();
    return http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
    );
  }
}
```

---

## ♿ Accessibility Specifications

### WCAG 2.1 Compliance

```dart
// Contrast ratios (WCAG AA minimum)
Coach Theme:
  - Text/Background: 7:1 (AAA level)
  - Accent/Background: 4.5:1 (AA level)
  
Client Theme:  
  - Text/Background: 12:1 (AAA level)
  - Accent/Background: 6:1 (AAA level)

// Touch targets
Minimum: 44x44 dp (iOS HIG + Material Design)
Recommended: 48x48 dp
Spacing: 8dp minimum between targets

// Focus indicators
Ring thickness: 2dp
Ring color: Primary accent color
Ring offset: 2dp from element
```

### Accessibility Implementation

```dart
class AccessibleGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final String? semanticsHint;
  
  const AccessibleGlassButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.semanticsLabel,
    this.semanticsHint,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? text,
      hint: semanticsHint,
      button: true,
      enabled: onPressed != null,
      child: GlassButton(
        text: text,
        onPressed: onPressed,
      ),
    );
  }
}

// Screen reader support
class AccessibleGlassCard extends StatelessWidget {
  final Widget child;
  final String? semanticsLabel;
  final bool isHeader;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      header: isHeader,
      container: true,
      child: GlassCard(child: child),
    );
  }
}
```

### Screen Reader Testing

```dart
// Test scenarios
1. Navigation avec VoiceOver (iOS) / TalkBack (Android)
2. Lecture des états (enabled/disabled/loading)  
3. Description des composants glassmorphism
4. Navigation au clavier (focus management)
5. Zoom jusqu'à 200% (layout reste fonctionnel)
```

---

## 🧪 Testing Specifications

### Unit Tests

```dart
// Theme switching tests
void main() {
  group('MyCoachDesignSystem', () {
    test('should switch to coach theme', () {
      MyCoachDesignSystem.setUserType(true);
      expect(MyCoachDesignSystem.isCoachTheme, true);
      expect(MyCoachColors.current.accentPrimary, CoachColors.accentPrimary);
    });
    
    test('should switch to client theme', () {
      MyCoachDesignSystem.setUserType(false);
      expect(MyCoachDesignSystem.isCoachTheme, false);
      expect(MyCoachColors.current.accentPrimary, ClientColors.accentPrimary);
    });
    
    test('should toggle dark mode', () {
      final initialState = MyCoachDesignSystem.isDarkMode;
      MyCoachDesignSystem.toggleDarkMode();
      expect(MyCoachDesignSystem.isDarkMode, !initialState);
    });
  });
}
```

### Widget Tests

```dart
void main() {
  group('GlassButton', () {
    testWidgets('should render with correct text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );
      
      expect(find.text('Test Button'), findsOneWidget);
    });
    
    testWidgets('should trigger onPressed callback', (tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassButton(
              text: 'Test',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(GlassButton));
      expect(pressed, true);
    });
  });
}
```

### Integration Tests

```dart
void main() {
  group('Theme Integration', () {
    testWidgets('complete user journey with theme switching', (tester) async {
      await tester.pumpWidget(MyCoachApp());
      
      // Start at onboarding
      expect(find.byType(OnboardingWelcomeScreen), findsOneWidget);
      
      // Select coach role
      await tester.tap(find.text('Coach Pro'));
      await tester.pumpAndSettle();
      
      // Verify theme switch
      expect(MyCoachDesignSystem.isCoachTheme, true);
      
      // Verify UI reflects coach theme
      expect(find.byType(AuthScreen), findsOneWidget);
      // Add more theme-specific assertions...
    });
  });
}
```

---

## 📊 Analytics & Monitoring

### Performance Monitoring

```dart
class PerformanceMonitor {
  static void trackFrameRate() {
    WidgetsBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        final fps = 1000 / timing.totalSpan.inMilliseconds;
        if (fps < 55) { // Below 55 FPS
          FirebaseAnalytics.instance.logEvent(
            name: 'performance_issue',
            parameters: {
              'fps': fps,
              'screen': _getCurrentScreen(),
              'device': Platform.operatingSystem,
            },
          );
        }
      }
    });
  }
  
  static void trackGlassmorphismPerformance() {
    // Track if glassmorphism effects cause performance issues
  }
}
```

### Design System Usage Analytics

```dart
class DesignSystemAnalytics {
  static void trackThemeSwitch(bool isCoach) {
    FirebaseAnalytics.instance.logEvent(
      name: 'theme_switch',
      parameters: {
        'theme_type': isCoach ? 'coach' : 'client',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  static void trackComponentUsage(String componentName) {
    FirebaseAnalytics.instance.logEvent(
      name: 'component_usage',
      parameters: {
        'component': componentName,
        'theme': MyCoachDesignSystem.isCoachTheme ? 'coach' : 'client',
      },
    );
  }
}
```

---

## 🚀 Deployment Checklist

### Pre-Release Validation

```dart
// Performance benchmarks
✅ 60 FPS on target devices
✅ < 3s cold start time
✅ < 150MB memory usage
✅ Smooth glassmorphism on mid-range devices

// Design consistency  
✅ All screens use design system components
✅ No hardcoded colors/fonts outside design system
✅ Consistent spacing using MyCoachSpacing
✅ Proper accessibility labels

// Theme validation
✅ Coach/Client themes work across all screens
✅ Dark mode toggle functional (if implemented)
✅ Theme persistence works correctly
✅ No theme leaks between user types

// Backend integration
✅ API endpoints configured correctly  
✅ Authentication flow complete
✅ Error handling implemented
✅ Offline graceful degradation

// Testing
✅ Unit tests pass (95%+ coverage)
✅ Widget tests pass 
✅ Integration tests pass
✅ Manual testing on target devices
✅ Accessibility testing completed
```

### Production Configuration

```dart
// Release build optimizations
flutter build apk --release --obfuscate --split-debug-info=debug-info/

// Performance flags
--tree-shake-icons
--split-per-abi  
--analyze-size

// Security
- Enable R8 obfuscation
- Remove debug information
- Validate all API keys are production
- Enable ProGuard rules for glassmorphism libraries
```

---

## 🔮 Future Roadmap

### Phase 2 Enhancements

```dart
// Advanced themes
- Seasonal color variants
- User-customizable accent colors  
- Premium glassmorphism effects
- Animated gradients

// Performance
- Adaptive quality based on device
- Precomputed blur textures
- GPU-accelerated animations
- Memory optimization for large lists

// Accessibility
- High contrast mode
- Reduced motion preferences  
- Voice navigation support
- Custom font size scaling

// Analytics
- Component usage tracking
- Performance bottleneck detection
- User theme preference insights
- A/B testing framework for design changes
```

---

## 📞 Technical Support

### Development Environment Setup

```bash
# Recommended Flutter version
Flutter 3.24.0+ • Dart 3.5.0+

# Required dependencies
flutter pub add provider
flutter pub add flutter_secure_storage
flutter pub add http
flutter pub add shared_preferences

# Development tools
flutter pub add --dev flutter_test
flutter pub add --dev integration_test
flutter pub add --dev flutter_driver
```

### Common Issues & Solutions

```dart
// Issue: Glassmorphism performance on low-end Android
Solution: Implement adaptive blur levels based on device capability

// Issue: Theme not persisting between app restarts  
Solution: Use SecurePreferences to store theme state

// Issue: Font rendering inconsistent
Solution: Ensure Space Grotesk fonts properly bundled in assets

// Issue: Navigation animations janky
Solution: Use GlassSlideTransition with reduced complexity on slow devices
```

---

Cette spécification technique complète le Design System MyCoach et fournit tous les détails nécessaires pour une implémentation production robuste et performante. 🚀