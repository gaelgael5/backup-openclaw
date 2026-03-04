# MyCoach Design System - Guide d'Intégration Flutter

> **🚀 OBJECTIF :** Design System complet prêt pour intégration immédiate  
> **✅ STATUS :** Production Ready - Copy/Paste dans votre projet Flutter  
> **⚡ HIGHLIGHTS :** Thèmes duaux, Glassmorphism, Animations, Responsive

---

## 🎯 Vue d'ensemble

Ce Design System MyCoach implémente **deux identités visuelles distinctes** :

- **🌑 Coach Theme** : Dark tech premium pour les professionnels
- **🌕 Client Theme** : Light dynamic pour les utilisateurs finaux  

**Switch automatique** selon le type d'utilisateur + **dark/light mode** pour chaque rôle.

---

## 📦 Installation & Setup

### 1. Ajouter les fichiers au projet

```bash
# Copier les fichiers dans votre projet Flutter
lib/
├── design_system/
│   ├── design_system.dart       # ✅ Core system
│   └── screens_complete.dart    # ✅ Écrans prêts à l'usage
├── main.dart                    # ✅ À modifier
└── pubspec.yaml                 # ✅ Dépendances à ajouter
```

### 2. Dépendances pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Dépendances existantes...

fonts:
  - family: Space Grotesk
    fonts:
      - asset: assets/fonts/SpaceGrotesk-Regular.ttf
        weight: 400
      - asset: assets/fonts/SpaceGrotesk-Medium.ttf
        weight: 500
      - asset: assets/fonts/SpaceGrotesk-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/SpaceGrotesk-Bold.ttf
        weight: 700
      - asset: assets/fonts/SpaceGrotesk-ExtraBold.ttf
        weight: 800
      - asset: assets/fonts/SpaceGrotesk-Black.ttf
        weight: 900
```

### 3. Télécharger Space Grotesk

```bash
# Google Fonts ou GitHub : https://github.com/floriankarsten/space-grotesk
# Placer les fichiers dans assets/fonts/
```

---

## 🚀 Intégration dans main.dart

### Setup de base

```dart
import 'package:flutter/material.dart';
import 'design_system/design_system.dart';
import 'design_system/screens_complete.dart';

void main() {
  runApp(MyCoachApp());
}

class MyCoachApp extends StatefulWidget {
  @override
  _MyCoachAppState createState() => _MyCoachAppState();
}

class _MyCoachAppState extends State<MyCoachApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCoach',
      
      // 🎨 THEME AUTOMATIQUE basé sur le type d'utilisateur
      theme: MyCoachTheme.currentTheme,
      
      // 🌙 Support dark mode (optionnel)
      darkTheme: MyCoachDesignSystem.isCoachTheme 
        ? MyCoachTheme.getCoachTheme() 
        : MyCoachTheme.getClientTheme(),
      
      // 🎬 Page d'accueil
      home: OnboardingWelcomeScreen(),
      
      // 🔧 Configuration supplémentaire
      debugShowCheckedModeBanner: false,
      
      // 🎨 Override des couleurs système (status bar, etc.)
      builder: (context, child) {
        return Theme(
          data: MyCoachTheme.currentTheme,
          child: child!,
        );
      },
    );
  }
}
```

### Gestion du state global du thème (optionnel)

```dart
// Pour rebuilder l'app quand le thème change
class MyCoachApp extends StatefulWidget {
  static _MyCoachAppState? _instance;
  
  static void rebuildApp() {
    _instance?.setState(() {});
  }
  
  @override
  _MyCoachAppState createState() {
    _instance = _MyCoachAppState();
    return _instance!;
  }
}

// Dans vos écrans, pour changer le thème :
void switchUserType(bool isCoach) {
  MyCoachDesignSystem.setUserType(isCoach);
  MyCoachApp.rebuildApp(); // Rebuilds toute l'app
}
```

---

## 🎨 Utilisation des Composants

### 1. Couleurs

```dart
// ✅ Couleurs automatiques selon le thème actuel
Container(
  color: MyCoachColors.current.backgroundPrimary,
  child: Text(
    'Hello',
    style: TextStyle(color: MyCoachColors.current.textPrimary),
  ),
)

// ✅ Couleurs spécifiques à un thème
Container(
  color: MyCoachColors.coach.accentPrimary, // Orange électrique
  child: Text(
    'Coach Mode',
    style: TextStyle(color: CoachColors.textPrimary),
  ),
)

Container(
  color: MyCoachColors.client.accentPrimary, // Cyan électrique  
  child: Text(
    'Client Mode',
    style: TextStyle(color: ClientColors.textPrimary),
  ),
)
```

### 2. Typography

```dart
// ✅ Typography automatique
Text(
  'Titre principal',
  style: MyCoachTypography.titleL, // S'adapte au thème
)

Text(
  'Corps de texte',
  style: MyCoachTypography.bodyM,
)

// ✅ Typography spécifique
Text(
  'Coach only',
  style: MyCoachTypography.coachTitleXL,
)

Text(
  'Client only',
  style: MyCoachTypography.clientTitleXL,
)
```

### 3. Glassmorphism Cards

```dart
// ✅ Glass Card basic
GlassCard(
  level: 2, // 1-4 (blur intensity)
  child: Column(
    children: [
      Text('Contenu de la carte'),
      // ...
    ],
  ),
)

// ✅ Glass Card avec personnalisation
GlassCard(
  level: 3,
  width: double.infinity,
  height: 200,
  padding: EdgeInsets.all(24),
  borderRadius: BorderRadius.circular(20),
  child: YourWidget(),
)
```

### 4. Glass Buttons

```dart
// ✅ Button primary avec glassmorphism
GlassButton(
  text: 'Commencer',
  onPressed: () {
    // Action
  },
)

// ✅ Button avec icône
GlassButton(
  text: 'Nouveau workout',
  icon: Icon(Icons.add, color: Colors.white),
  width: double.infinity,
  height: 56,
  onPressed: () {},
)

// ✅ Button styles
GlassButton(
  text: 'Secondary Action',
  style: GlassButtonStyle.secondary,
  onPressed: () {},
)
```

### 5. Text Fields

```dart
// ✅ TextField avec glassmorphism
MyCoachTextField(
  label: 'Email',
  hint: 'votre@email.com',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icon(
    Icons.email,
    color: MyCoachColors.current.accentPrimary,
  ),
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Requis';
    return null;
  },
)
```

### 6. Bottom Navigation

```dart
// ✅ Navigation avec glassmorphism
MyCoachBottomNav(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  items: [
    MyCoachNavItem(icon: Icons.home, label: 'Accueil'),
    MyCoachNavItem(icon: Icons.fitness_center, label: 'Workouts'),
    MyCoachNavItem(icon: Icons.person, label: 'Profil'),
  ],
)
```

### 7. Glass Container (générique)

```dart
// ✅ Container glassmorphism custom
GlassContainer(
  width: 200,
  height: 100,
  blurSigma: 25.0, // Intensité blur
  borderColor: MyCoachColors.current.accentPrimary,
  child: Center(
    child: Text('Glass Effect'),
  ),
)
```

---

## 🎭 Switch de Thème Dynamique

### Méthode 1 : Global state

```dart
class ThemeManager extends ChangeNotifier {
  bool _isCoachTheme = true;
  
  bool get isCoachTheme => _isCoachTheme;
  
  void setUserType(bool isCoach) {
    _isCoachTheme = isCoach;
    MyCoachDesignSystem.setUserType(isCoach);
    notifyListeners();
  }
}

// Dans main.dart avec Provider
ChangeNotifierProvider(
  create: (context) => ThemeManager(),
  child: Consumer<ThemeManager>(
    builder: (context, themeManager, child) {
      return MaterialApp(
        theme: MyCoachTheme.currentTheme,
        home: YourHomePage(),
      );
    },
  ),
)
```

### Méthode 2 : Switch simple

```dart
// Dans vos Settings
Switch(
  value: MyCoachDesignSystem.isCoachTheme,
  onChanged: (isCoach) {
    MyCoachDesignSystem.setUserType(isCoach);
    // Trigger rebuild de votre widget parent
    setState(() {});
  },
)
```

---

## 🎬 Animations & Transitions

### Page Transitions

```dart
// ✅ Transition glassmorphism entre écrans
Navigator.push(
  context,
  GlassSlideTransition(
    child: YourNextScreen(),
  ),
);
```

### Animations personnalisées

```dart
// ✅ Utilisation des courbes MyCoach
AnimationController _controller = AnimationController(
  duration: MyCoachAnimations.standard, // 300ms
  vsync: this,
);

Animation<double> _animation = Tween<double>(
  begin: 0.0,
  end: 1.0,
).animate(CurvedAnimation(
  parent: _controller,
  curve: MyCoachAnimations.easeOutExpo, // Courbe signature
));
```

### Micro-interactions

```dart
// ✅ Button avec micro-animation intégrée (déjà dans GlassButton)
// ✅ Cards avec hover effects (déjà dans GlassCard)
// ✅ Input focus avec glow (déjà dans MyCoachTextField)
```

---

## 📱 Responsive Design

### Spacing système

```dart
// ✅ Spacing cohérent
Padding(
  padding: EdgeInsets.all(MyCoachSpacing.lg), // 24px
)

SizedBox(height: MyCoachSpacing.xl), // 32px

Column(
  children: [
    Widget1(),
    SizedBox(height: MyCoachSpacing.md), // 16px
    Widget2(),
  ],
)
```

### Border radius

```dart
// ✅ Radius cohérent
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(MyCoachBorderRadius.lg), // 16px
  ),
)
```

### Breakpoints (à implémenter selon vos besoins)

```dart
// ✅ Responsive helper (à ajouter si nécessaire)
class Responsive {
  static bool isMobile(BuildContext context) => 
    MediaQuery.of(context).size.width < 768;
  
  static bool isTablet(BuildContext context) => 
    MediaQuery.of(context).size.width >= 768 && 
    MediaQuery.of(context).size.width < 1024;
  
  static bool isDesktop(BuildContext context) => 
    MediaQuery.of(context).size.width >= 1024;
}
```

---

## 🔧 Customisation Avancée

### Ajouter de nouvelles couleurs

```dart
// Dans design_system.dart, ajouter dans CoachColors/ClientColors :
static const Color customBlue = Color(0xFF1E3A8A);
static const Color customGreen = Color(0xFF059669);
```

### Nouveaux composants glassmorphism

```dart
class CustomGlassWidget extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    final isCoach = MyCoachDesignSystem.isCoachTheme;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: isCoach ? _coachGradient() : _clientGradient(),
            border: Border.all(/* ... */),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

### Nouvelles animations

```dart
class CustomAnimation {
  static const Curve bounceInOut = Cubic(0.68, -0.55, 0.265, 1.55);
  
  static Animation<Offset> slideFromBottom(AnimationController controller) {
    return Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: MyCoachAnimations.easeOutExpo,
    ));
  }
}
```

---

## 📋 Checklist Intégration

### ✅ Setup Initial
- [ ] Copier `design_system.dart` dans `lib/design_system/`
- [ ] Copier `screens_complete.dart` dans `lib/design_system/`  
- [ ] Ajouter Space Grotesk font dans `assets/fonts/`
- [ ] Modifier `pubspec.yaml` avec les fonts
- [ ] Modifier `main.dart` avec le setup de base

### ✅ Thèmes
- [ ] Tester le switch Coach/Client theme
- [ ] Vérifier les couleurs sur différents écrans
- [ ] Tester la navigation avec les thèmes
- [ ] Valider l'accessibilité (contraste)

### ✅ Composants
- [ ] Remplacer les Card natives par GlassCard
- [ ] Remplacer les Button natives par GlassButton  
- [ ] Remplacer les TextField par MyCoachTextField
- [ ] Utiliser MyCoachTypography pour tous les textes
- [ ] Implémenter MyCoachBottomNav

### ✅ Animations
- [ ] Ajouter GlassSlideTransition aux navigations
- [ ] Tester les micro-animations des boutons
- [ ] Vérifier les courbes d'animation
- [ ] Performance sur devices bas de gamme

### ✅ Responsive
- [ ] Tester sur mobile (375px-667px)
- [ ] Tester sur tablet (768px-1024px)
- [ ] Vérifier les touch targets (min 44px)
- [ ] Tester l'accessibilité (screen readers)

---

## 🎯 Patterns d'Usage

### Écran typique Coach

```dart
class CoachStatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyCoachColors.current.backgroundPrimary,
      appBar: AppBar(
        title: Text('Analytics', style: MyCoachTypography.titleL),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(MyCoachSpacing.lg),
          child: Column(
            children: [
              // Header card
              GlassCard(
                level: 2,
                child: StatsHeader(),
              ),
              
              SizedBox(height: MyCoachSpacing.xl),
              
              // Content
              Expanded(
                child: ListView(
                  children: [
                    GlassCard(level: 3, child: ChartWidget()),
                    SizedBox(height: MyCoachSpacing.lg),
                    GlassCard(level: 2, child: MetricsGrid()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Écran typique Client

```dart
class ClientWorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyCoachColors.current.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Hero section
            GlassContainer(
              width: double.infinity,
              height: 200,
              child: WorkoutHero(),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(MyCoachSpacing.lg),
                child: Column(
                  children: [
                    GlassCard(
                      level: 2,
                      child: ExerciseList(),
                    ),
                    
                    SizedBox(height: MyCoachSpacing.xl),
                    
                    GlassButton(
                      text: 'Start Workout',
                      width: double.infinity,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🐛 Troubleshooting

### Performance glassmorphism

```dart
// ✅ Si lag sur devices bas de gamme, réduire blur
GlassCard(
  level: 1, // Moins de blur = plus de performance
  child: YourContent(),
)

// ✅ Ou conditionnellement
final blurLevel = Platform.isAndroid && 
  MediaQuery.of(context).devicePixelRatio < 2.0 ? 1 : 2;

GlassCard(level: blurLevel, child: YourContent())
```

### Conflits de thème

```dart
// ✅ Forcer rebuild après changement de thème
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Widget se rebuildera automatiquement si le thème change
  }
}
```

### Fonts manquantes

```dart
// ✅ Fallback si Space Grotesk indisponible
static const String primaryFont = 'Space Grotesk';
static const String fallbackFont = 'Inter'; // ou 'system-ui'

TextStyle(
  fontFamily: primaryFont,
  fontFamilyFallback: [fallbackFont, 'sans-serif'],
  // ...
)
```

---

## 🚀 Prochaines Étapes

### Roadmap d'amélioration

1. **Week 1** : Intégration de base + tests sur tous les écrans
2. **Week 2** : Performance optimisation + animations avancées  
3. **Week 3** : Composants spécialisés (charts, calendars, etc.)
4. **Week 4** : Dark mode complet + accessibilité premium

### Évolutions possibles

- **Thème saisonnier** : Variants de couleurs selon la saison
- **Personnalisation utilisateur** : Custom accent colors  
- **Animation avancées** : Parallax, morphing, physics-based
- **Composants métier** : Workout cards, progress charts, etc.

---

## 📞 Support

### Questions fréquentes

**Q: Comment ajouter un nouveau thème ?**  
A: Créer une nouvelle classe de couleurs (ex: `PremiumColors`) et l'ajouter dans `MyCoachColors.current`.

**Q: Performance sur Android bas de gamme ?**  
A: Réduire les niveaux de blur glassmorphism et désactiver certaines animations.

**Q: Accessibilité ?**  
A: Le système respecte les contrastes WCAG. Tester avec TalkBack/VoiceOver.

**Q: Backend intégration ?**  
A: Le design system est agnostique. Fonctionne avec n'importe quel backend Flutter (Provider, Bloc, Riverpod, etc.).

---

## ✨ Conclusion

Ce Design System MyCoach est **production-ready** et conçu pour une intégration immédiate. Il implemente les dernières tendances UI 2026 tout en restant performant et accessible.

**Copy/paste** le code, **adaptez** selon vos besoins spécifiques, et obtenez une interface **WOW** en quelques heures plutôt qu'en semaines ! 🚀

---

> **💡 Pro Tip :** Commencez par intégrer les écrans d'onboarding et d'auth, puis étendez progressivement aux autres écrans de votre app. Le système est modulaire et s'adapte facilement à vos besoins existants.