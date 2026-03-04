# MyCoach — Mobile UX Guidelines

> Guide du design system cohérent | Standards d'implémentation Mobile
> Stack : Flutter + Material 3 | Police : Inter | Version : 1.0
> Date : 2026-03-02

---

## Principes fondamentaux

### Vision UX
MyCoach simplifie la relation coach-client par une expérience mobile-first intuitive, accessible et motivante.

**Valeurs centrales :**
1. **Simplicité** : chaque action doit être évidente
2. **Proximité** : renforcer le lien humain coach-client  
3. **Motivation** : célébrer les progrès, encourager la régularité
4. **Professionnalisme** : inspirer confiance et expertise

### Persona primary : Sarah, Coach Fitness
- **Âge** : 28-35 ans
- **Context** : gère 10-15 clients, mobile 90% du temps
- **Pain points** : coordination planning, suivi progress clients, communication dispersée
- **Goals** : efficacité administrative, focus sur le coaching, croissance business

---

## Design Tokens (Material 3)

### Palette couleurs

#### Couleurs principales
| Token | Hex | Usage | Accessibilité |
|---|---|---|---|
| **primary** | #2563EB | CTA, navigation, focus | 4.5:1 sur blanc |
| **onPrimary** | #FFFFFF | Texte/icônes sur primary | 4.5:1 sur #2563EB |
| **primaryContainer** | #DBEAFE | Backgrounds légers, badges | - |
| **secondary** | #10B981 | Succès, completion, accents | 4.5:1 sur blanc |
| **secondaryContainer** | #D1FAE5 | Backgrounds positifs | - |

#### Couleurs fonctionnelles  
| Token | Hex | Usage |
|---|---|---|
| **surface** | #FFFFFF | Backgrounds cards, modals |
| **surfaceVariant** | #F1F5F9 | Inputs, backgrounds secondaires |  
| **onSurface** | #0F172A | Texte principal, headlines |
| **onSurfaceVariant** | #64748B | Texte secondaire, hints |
| **outline** | #CBD5E1 | Bordures, dividers |
| **error** | #EF4444 | Erreurs, actions destructives |
| **errorContainer** | #FEE2E2 | Backgrounds erreur |
| **warning** | #F59E0B | Alertes, états attention |
| **warningContainer** | #FEF3C7 | Backgrounds avertissement |

#### Usage par context
```
Succès → #10B981 (secondary)
Progress → #2563EB (primary) 
Attention → #F59E0B (warning)
Erreur → #EF4444 (error)
Neutre → #64748B (onSurfaceVariant)
```

### Typography (Inter)

#### Hiérarchie des styles
| Style | Taille | Weight | Line | Usage | Code Flutter |
|---|---|---|---|---|---|
| **displayLarge** | 32sp | 700 | 40sp | Splash, onboarding | Theme.of(context).textTheme.displayLarge |
| **headlineMedium** | 24sp | 700 | 32sp | Titres d'écrans | headlineMedium |
| **titleLarge** | 20sp | 600 | 28sp | Titres de sections | titleLarge |
| **titleMedium** | 16sp | 600 | 24sp | Titres de cards | titleMedium |
| **bodyLarge** | 16sp | 400 | 24sp | Texte principal | bodyLarge |
| **bodyMedium** | 14sp | 400 | 20sp | Texte courant | bodyMedium |
| **bodySmall** | 12sp | 400 | 16sp | Captions, metadata | bodySmall |
| **labelLarge** | 14sp | 600 | 20sp | Boutons, CTAs | labelLarge |
| **labelMedium** | 12sp | 500 | 16sp | Chips, badges | labelMedium |
| **labelSmall** | 10sp | 500 | 14sp | Micro-labels, timestamps | labelSmall |

#### Règles d'usage
- **Headlines** : maximum 2 lignes, ellipsis si débordement
- **Body text** : line-height 1.4-1.6 pour lisibilité optimale
- **Labels** : toujours CAPS ou sentence case, jamais camelCase UI
- **Contrast ratio** : minimum 4.5:1 pour tout texte <18sp

### Espacements

#### Système de grille (multiples de 4dp)
```dart
// Spacing tokens  
xs: 4.0,    // Micro-spacings internes
sm: 8.0,    // Spacings serrés  
md: 12.0,   // Spacings standards cards
base: 16.0, // Spacing de base (default)
lg: 20.0,   // Spacings généreux
xl: 24.0,   // Spacings larges entre sections
2xl: 32.0,  // Spacings très larges
3xl: 48.0,  // Spacings splash/onboarding
```

#### Application
- **Padding horizontal écrans** : 16dp (base)
- **Padding vertical sections** : 24dp (xl) 
- **Gap entre cards** : 12dp (md)
- **Padding interne cards** : 16dp (base)
- **Safe areas** : respecter notch + navigation gesture

### Rayons de courbure
```dart
radiusSm: 8.0,   // Chips, petits éléments
radiusMd: 12.0,  // Cards, inputs (standard)
radiusLg: 16.0,  // Modals, dialogs
radiusXl: 24.0,  // Grandes surfaces  
radiusFull: 999, // Cercles parfaits (avatars, FAB)
```

---

## Composants fondamentaux

### Buttons

#### FilledButton (CTA primary)
```dart
FilledButton.styleFrom(
  minimumSize: Size(double.infinity, 52), // height obligatoire 52dp
  backgroundColor: Color(0xFF2563EB),
  foregroundColor: Color(0xFFFFFFFF),
  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  elevation: 0, // Material 3 = no elevation sur filled
)
```

**Usage :** actions principales, soumission forms, navigation forward
**États :** disabled (bg: #CBD5E1, fg: #64748B), loading (CircularProgressIndicator blanc)

#### OutlinedButton (CTA secondary)  
```dart
OutlinedButton.styleFrom(
  minimumSize: Size(double.infinity, 48), // légèrement plus petit
  side: BorderSide(color: Color(0xFFCBD5E1)),
  foregroundColor: Color(0xFF0F172A),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
)
```

**Usage :** actions secondaires, annulation, alternatives

#### TextButton (actions tertiaires)
```dart
TextButton.styleFrom(
  foregroundColor: Color(0xFF2563EB),
  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
)
```

**Usage :** navigation, liens, actions non critiques

### Inputs

#### TextField standard
```dart
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Color(0xFFF1F5F9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFFCBD5E1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), 
      borderSide: BorderSide(color: Color(0xFF2563EB), width: 2),
    ),
    contentPadding: EdgeInsets.all(16),
    hintStyle: TextStyle(color: Color(0xFF94A3B8)),
  ),
)
```

**Variants :**
- **Success** : border #10B981, suffix icon check
- **Error** : border #EF4444, helper text rouge
- **Disabled** : bg #F8FAFC, border #E2E8F0

### Cards

#### Card standard
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Color(0xFFF1F5F9)),
    boxShadow: [
      BoxShadow(
        color: Color(0x0A000000), // shadow très subtile
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
    ],
  ),
)
```

**Usage :** conteneurs d'information, groupement logique
**Variants :** card avec header coloré, card interactive (+ border active)

### Navigation

#### BottomNavigationBar
```dart
NavigationBar(
  height: 80, // include safe area
  backgroundColor: Colors.white,
  indicatorColor: Color(0xFFDBEAFE),
  destinations: [...],
)
```

**Rules :**
- **5 items maximum** : sinon navigation drawer
- **Icons filled/outlined** : état selected/unselected
- **Badge notifications** : cercle rouge 8dp, max "99+"

---

## Patterns d'interaction

### Touch targets
- **Minimum size** : 48×48dp (Material guidelines)
- **Optimal size** : 52dp height pour boutons principaux
- **Spacing** : 8dp minimum entre touch targets adjacents

### Gestures
- **Tap** : sélection, navigation, actions
- **Long press** : menu contextuel, preview
- **Swipe horizontal** : navigation entre tabs, dismiss cards
- **Swipe vertical** : refresh (pull-down), infinite scroll
- **Pinch** : zoom images (si applicable)

### Feedback haptic
```dart
// Sélection légère
HapticFeedback.selectionClick();

// Action importante (réservation confirmée)
HapticFeedback.mediumImpact(); 

// Erreur critique
HapticFeedback.heavyImpact();
```

**Usage :**
- Selection click : tap sur chips, cards sélectionnables
- Medium impact : succès actions importantes (paiement, création)
- Heavy impact : erreurs critiques, warning destructive

### Animations & Transitions

#### Durées standards
```dart
// Micro-animations (hover, selection)
Duration(milliseconds: 100-200)

// Navigation entre écrans
Duration(milliseconds: 300)

// Modals, bottom sheets 
Duration(milliseconds: 250)

// Loading states
Duration(milliseconds: 400)
```

#### Curves recommandées
```dart
Curves.easeInOutCubic  // Navigation pages
Curves.easeOut         // Apparition éléments
Curves.elasticOut      // Success states (bounce)
```

---

## États & Loading

### Loading states

#### Shimmer (recommandé)
```dart
Shimmer.fromColors(
  baseColor: Color(0xFFF1F5F9),
  highlightColor: Color(0xFFE2E8F0),
  child: Container(...), // même dimensions que contenu final
)
```

**Usage :** listes, cards, contenus avec structure prévisible

#### Circular Progress
```dart  
CircularProgressIndicator(
  strokeWidth: 3,
  valueColor: AlwaysStoppedAnimation(Color(0xFF2563EB)),
)
```

**Tailles :** 20×20dp (boutons), 32×32dp (pages), 48×48dp (splash)

#### Linear Progress
```dart
LinearProgressIndicator(
  backgroundColor: Color(0xFFF1F5F9),
  valueColor: AlwaysStoppedAnimation(Color(0xFF10B981)),
  minHeight: 6,
)
```

**Usage :** progression forms, upload, tâches avec % completion

### Empty states

#### Structure type
```
[Illustration] Icons.size_large + cercle background
[Titre] headlineSmall, message principal
[Sous-titre] bodyMedium, explication/conseil
[Action] FilledButton pour débloquer la situation
```

#### Icônes recommandées
- **Clients vides** : Icons.people_outline
- **Messages vides** : Icons.chat_bubble_outline  
- **Calendrier vide** : Icons.event_available_outlined
- **Recherche vide** : Icons.search_off
- **Erreur réseau** : Icons.wifi_off

### Error states

#### Error patterns
```dart
Column(
  children: [
    Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
    SizedBox(height: 16),
    Text("Quelque chose s'est mal passé", style: headlineSmall),
    SizedBox(height: 8),
    Text("Message d'erreur explicite", style: bodyMedium),
    SizedBox(height: 24),
    FilledButton(onPressed: retry, child: Text("Réessayer")),
  ],
)
```

---

## Accessibilité

### Contrast ratios
- **Texte normal (<18sp)** : minimum 4.5:1
- **Texte large (≥18sp)** : minimum 3:1  
- **Éléments UI non-text** : minimum 3:1

### Semantic labels
```dart
Semantics(
  label: "Réserver une séance avec Sarah Martin",
  button: true,
  child: IconButton(...),
)
```

**Required pour :**
- Tous IconButton sans label visible
- Images informatives (photos profil, exercices)
- États dynamiques (progress, loading)

### Navigation clavier
- **Tab order** logique : top→bottom, left→right
- **Focus indicators** : outline 2dp #2563EB, radius matching element
- **Skip links** : navigation rapide vers contenu principal

### Tailles de police
Respecter les préférences système :
```dart
Text(
  "Content",
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! * 
              MediaQuery.of(context).textScaleFactor,
  ),
)
```

---

## Mobile responsive

### Breakpoints
```dart
// Mobile portrait (default)
width < 600dp

// Mobile landscape  
width >= 600dp && width < 960dp

// Tablet
width >= 960dp
```

### Adaptive layouts

#### Mobile portrait (primary target)
- **Single column** layout
- **Full-width** cards et buttons
- **Bottom navigation** bar

#### Mobile landscape
- **Constrain content width** : max 480dp, center
- **Reduce vertical spacing** légèrement  
- **Side-by-side** pour certaines actions

#### Tablet  
- **Master-detail** pattern pour listes
- **Max content width** : 680dp
- **Navigation rail** au lieu de bottom bar

### Safe areas
```dart
SafeArea(
  child: Scaffold(...),
) 

// Ou padding explicite
EdgeInsets.only(
  top: MediaQuery.of(context).padding.top,
  bottom: MediaQuery.of(context).padding.bottom,
)
```

---

## Performance guidelines

### Images
- **Format** : WebP preferred, PNG fallback
- **Sizes** : 1x, 2x, 3x variants pour différentes densités
- **Caching** : CachedNetworkImage obligatoire
- **Placeholder** : shimmer ou blurhash

### Lists
- **ListView.builder** obligatoire pour >10 items
- **Pagination** : 20 items par page recommended
- **Keep-alive** : TabBarView avec AutomaticKeepAliveClientMixin

### State management
- **BLoC pattern** pour business logic
- **Provider** pour UI state simple
- **SharedPreferences** pour settings persistants
- **Secure storage** pour tokens auth

---

## Checklist qualité UX

### Design review checklist

#### Cohérence
- [ ] Couleurs conformes au design system
- [ ] Typography respectant les scales définies  
- [ ] Spacings multiples de 4dp
- [ ] Rayons cohérents par type de composant

#### Accessibilité
- [ ] Contrast ratios validés (WCAG AA)
- [ ] Touch targets ≥ 48×48dp
- [ ] Labels sémantiques sur éléments interactifs
- [ ] Navigation clavier testée

#### States
- [ ] Loading states implémentés  
- [ ] Empty states avec actions claires
- [ ] Error states avec recovery actions
- [ ] Success feedback visible

#### Performance
- [ ] ListView.builder sur listes longues
- [ ] Images optimisées et cached
- [ ] Animations fluides 60fps
- [ ] Bundle size < 20MB

#### Mobile UX
- [ ] Touch-friendly (thumb navigation zones)
- [ ] Keyboard avoidance sur inputs
- [ ] Orientation changes handled
- [ ] Back button behavior logique

### Testing checklist

#### Functional
- [ ] Happy path user journeys
- [ ] Error scenarios recovery
- [ ] Offline behavior graceful
- [ ] Navigation intuitive

#### Device coverage
- [ ] iPhone 14 (390×844) - référence iOS
- [ ] Galaxy S23 (360×780) - référence Android  
- [ ] iPhone SE (375×667) - petit écran
- [ ] iPad 10.9" (820×1180) - tablet

#### Network conditions
- [ ] Slow 3G performance
- [ ] Offline mode functionality
- [ ] Poor connectivity recovery
- [ ] Timeout handling

---

## Évolutions futures

### v1.1 roadmap UX
- **Dark mode** : palette couleurs alternative
- **Voice interactions** : commandes vocales planning
- **AR exercise preview** : prévisualisation exercices en réalité augmentée
- **Apple Watch** : notifications et quick actions

### v2.0 vision
- **AI coaching assistant** : suggestions automatiques programmes
- **Group sessions** : gestion cours collectifs
- **Marketplace** : vente programmes entre coaches
- **Analytics avancées** : insights progression IA

---

Ce guide assure une expérience utilisateur cohérente et professionnelle sur MyCoach, respectant les standards modernes de design mobile tout en préservant la simplicité d'usage.