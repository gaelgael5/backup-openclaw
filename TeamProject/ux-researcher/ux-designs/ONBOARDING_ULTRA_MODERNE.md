# MyCoach — Onboarding Ultra-Moderne 2026 🚀

> **Objectif :** Première impression WOW, sélection Coach/Client immersive, glassmorphism spectaculaire  
> **Inspiration :** Apple Vision Pro onboarding, Tesla interface, Spotify premium flows

---

## 📱 Screen 1 : Splash Futuriste

### Background
```
Gradient animé multi-couches :
1. Background base: #0A0A0F (Deep space)
2. Animated gradient: #FF6B35 → #8B5CF6 → #06FFA5 (flowing diagonal)
3. Particle overlay: Subtle floating particles avec glow
4. Grain texture: 2% opacity pour profondeur
```

### Center Content
```
[FLOATING LOGO - 120px]
🔥 Logo MyCoach glassmorphism ultra-premium :
- Container: 120×120px glass orb
- Background: radial gradient transparent→white@5%
- Backdrop blur: 40px
- Border: 1px solid white@20%
- Inner shadow: inset white@10%
- Outer glow: 0 0 60px orange@30%
- Icon: Fitness center symbol avec neon orange
- Animation: Slow rotation + pulsing glow

[HERO TEXT - Staggered Animation]
"MyCoach" → Title XL (48px), Weight 900, Neon text effect
- Color: Pure white avec subtle orange glow
- Animation: TypeWriter effect + letter-by-letter glow
- Delay: 800ms après logo

[TAGLINE - Ghost Animation]  
"L'avenir du coaching" → Title M (20px), Weight 400
- Color: white@70%
- Animation: FadeIn from bottom, 1200ms delay
- Subtle tracking animation (letter spacing grow)

[LOADING ELEMENT - Morphing]
Custom glassmorphism loader :
- Container: 200px wide, 6px height, glass background
- Progress bar: Flowing neon gradient orange→purple→cyan
- Animation: Smooth flow + occasional spark effects
- No percentage text (mysterious/premium feel)
```

### Transition
```
Après 3 secondes → Scale zoom logo + background blur intensify
Puis crossfade vers Role Selection avec glass transition effect
```

---

## 📱 Screen 2 : Sélection Rôle Immersive

### Background  
```
Même base gradient que splash, mais plus subtle
Parallax effet avec 3 couches glass qui bougent légèrement au tilt device
```

### Layout Breakdown

#### Header (120px)
```
[LOGO MINI - Top Center]
Reduced logo 48×48px, less glow, floating effet
"Commencer l'aventure" → Title L (24px) white@80%
```

#### Main Content (500px)
```
[COACH CARD - Left Half]
Position: Occupé 50% width, centré vertical
Glass container ultra-premium :
- Size: 320×400px (mobile 280×350px)  
- Background: Dark glass gradient
  └ rgba(255,255,255,0.08) → rgba(255,107,53,0.05)
- Backdrop blur: 25px
- Border: 1px solid orange@20%
- Corner radius: 24px
- Shadow: 0 12px 40px black@40%

Contenu interne :
┌─ [ICON ZONE - 100px height]
│  🔥 Orb icon 64×64px avec orange glow intense
│  Background: Orange gradient orb avec particles
│  Animation: Rotation lente + pulse sur hover
│
├─ [TEXT ZONE - 200px height]  
│  "Coach" → Title XL (32px) Bold white
│  "Gérer vos clients" → Body M (14px) white@70%
│  "Créer des programmes" → Body M (14px) white@70%
│  "Optimiser votre activité" → Body M (14px) white@70%
│
└─ [CTA ZONE - 100px height]
   Glass Button "Devenir Coach" :
   - Background: Orange gradient + glass
   - Glow effect on hover
   - Scale 1.05 + glow intensify

HOVER STATE: 
- Scale 1.02
- Glow intensify 150%
- Background blur increase
- Subtle rotation (2deg)

[CLIENT CARD - Right Half]  
Position: Occupé 50% width, centré vertical
Glass container premium :
- Size: 320×400px (mobile 280×350px)
- Background: Light glass gradient  
  └ rgba(255,255,255,0.5) → rgba(0,210,255,0.08)
- Backdrop blur: 20px
- Border: 1px solid cyan@25%
- Corner radius: 24px
- Shadow: 0 12px 40px cyan@15%

Contenu interne :
┌─ [ICON ZONE]
│  ✨ Orb icon 64×64px avec cyan glow
│  Background: Cyan gradient orb avec sparkles
│  Animation: Float + sparkle particles
│
├─ [TEXT ZONE]
│  "Client" → Title XL (32px) Bold dark
│  "Trouver votre coach" → Body M (14px) dark@80%
│  "Suivre vos progrès" → Body M (14px) dark@80%
│  "Atteindre vos objectifs" → Body M (14px) dark@80%
│
└─ [CTA ZONE]
   Glass Button "Je m'entraîne" :
   - Background: Cyan gradient + glass
   - Glow effect on hover
   - Scale 1.05 + shimmer

HOVER STATE:
- Scale 1.02  
- Glow intensify + sparkle animation
- Background shimmer effect
- Bounce micro-animation
```

#### Footer (120px)
```
[GHOST NAVIGATION]
"← Retour" TextButton white@50% (fantôme)
Center: Dots indicator (2 dots, glassmorphism style)
"Aide" TextButton white@50%
```

### Micro-Interactions
```
CARD TAP FEEDBACK:
- Haptic feedback medium
- Scale down 0.98 pour 100ms
- Glow pulse effect
- Glass compression visual
- Sound: Subtle glass clink

TILT GESTURES:
- Device tilt left/right = cards subtle parallax
- Gyroscope-based background movement
- Glass layers move at different speeds

AMBIENT ANIMATIONS:
- Floating particles behind glass
- Gradient background slow flow (60s cycle)
- Glass reflections shift subtly
- Card glow "breathing" (4s cycle)
```

### Transition Out
```
SELECTED COACH:
- Coach card scale up 1.1
- Client card fade + scale down 0.9  
- Orange glow explosion from coach card
- Screen transition: Orange gradient push left
- Crossfade to Coach Dark Theme setup

SELECTED CLIENT:
- Client card scale up 1.1
- Coach card fade + scale down 0.9
- Cyan sparkle explosion from client card
- Screen transition: Cyan gradient push right  
- Crossfade to Client Light Theme setup
```

---

## 📱 Screen 3 : Permission Request (Ultra-Modern)

### Background
```
Theme adaptatif (Coach=dark, Client=light)
Gradient base + glass overlay niveau 1
Subtle animated mesh background
```

### Layout
```
[HEADER - 80px]
"Presque prêt..." → Title L (24px) 
Sous-titre adaptatif theme

[MAIN CONTENT - 400px]
Center Glass Card (340×300px) :
- Background: Glass niveau 2 selon theme
- Icons zone: Permission symbols avec neon glow
- Text zone: Explications benefits
- CTA: Glass button avec theme glow

[PERMISSION ITEMS]
📍 Localisation → "Trouver des coachs/clients près de vous"
📷 Appareil photo → "Partager vos progrès visuels"  
🔔 Notifications → "Rester connecté à votre coach/client"
💾 Stockage → "Sauvegarder vos données localement"

Chaque item = Row avec :
- Icon dans glass orb (theme glow)
- Text explanation  
- Switch toggle (glassmorphism style)

[FOOTER CTA]
"Finaliser la configuration" → Theme glass button
"Plus tard" → Ghost text button
```

---

## 🎬 Animation Choreography

### Page Entry Sequence
```
1. Background (0ms)
   ↳ Fade in gradient base

2. Glass Background (200ms)  
   ↳ Blur effect intensify 0→25px over 400ms

3. Logo (400ms)
   ↳ Scale 0.5→1.0 + rotation + glow appear

4. Cards (800ms)
   ↳ Stagger left then right, 200ms gap
   ↳ Y-translate from 100px + opacity 0→1
   ↳ Glass effect build up

5. Ambient (1200ms)
   ↳ Particles start flowing
   ↳ Glow breathing animations begin
   ↳ Background gradient flow starts
```

### Gesture Responses
```
CARD HOVER (Desktop):
- Glass reflection shift
- Border glow intensify  
- Scale 1.02 over 150ms
- Inner content slight float up

CARD TAP (Mobile):
- Scale 0.98 for 100ms
- Glass "push" effect
- Ripple from tap point
- Haptic feedback
- Glass compression visual

DEVICE TILT:
- Parallax background layers
- Glass reflection angle change
- Card positioning subtle shift
- Particle movement direction influence
```

---

## 🎨 Visual Specifications

### Glass Effects Hierarchy
```
Level 1 - Background Glass:
- Blur: 40px
- Opacity: 0.05
- Border: 0px
- Use: Page backgrounds

Level 2 - Card Glass:  
- Blur: 25px
- Opacity: 0.08 (coach) / 0.5 (client)
- Border: 1px solid theme@20%
- Use: Main content cards

Level 3 - Component Glass:
- Blur: 15px  
- Opacity: 0.12
- Border: 1px solid theme@15%
- Use: Buttons, inputs, small elements

Level 4 - Accent Glass:
- Blur: 10px
- Opacity: 0.15
- Border: 1px solid theme@25%
- Use: Active states, highlights
```

### Glow System
```
Subtle Glow (Idle):
- Spread: 20px
- Color: theme@30%
- Blur: 20px

Medium Glow (Hover):
- Spread: 30px
- Color: theme@50% 
- Blur: 25px

Intense Glow (Active):
- Spread: 40px
- Color: theme@70%
- Blur: 30px

Hero Glow (Special):
- Multi-layer with different spreads
- Color shifting animation
- Pulsing intensity
```

### Typography Neon Effects
```
Hero Text (Logo):
text-shadow: 
  0 0 10px currentColor,
  0 0 20px currentColor,
  0 0 30px theme-primary,
  0 0 40px theme-primary;

Title Glow:
text-shadow:
  0 0 5px currentColor,
  0 0 10px theme-primary;

Subtle Accent:
text-shadow:
  0 0 3px currentColor;
```

---

## 📱 Responsive Adaptations

### Mobile Portrait (320px - 414px)
```
- Cards stack vertical instead horizontal
- Reduce blur effects for performance (15px max)
- Simplify glow effects  
- Touch targets min 44px
- Reduced animation complexity
- Single glass layer instead multi-layer
```

### Mobile Landscape (567px - 812px)
```
- Cards side by side with reduced padding
- Maintain full glass effects
- Optimize gesture recognition
- Adapt text sizing
```

### Tablet (768px - 1024px)
```
- Full desktop effects
- Enhanced hover states
- Grid layout options
- Multi-touch gestures
- Maximum blur and glow
```

---

## 🔧 Implementation Notes

### Performance Optimizations
```
- Use will-change CSS for animating elements
- Implement glass effects with CSS backdrop-filter
- Optimize blur radius for target devices
- Use transform3d for GPU acceleration  
- Implement reduced motion preferences
- Lazy load heavy visual effects
```

### Accessibility
```
- High contrast mode adaptations
- Reduced motion alternatives
- Screen reader compatible structure
- Keyboard navigation support
- Focus indicators with theme glow
- Alternative text for visual effects
```

### Flutter Considerations
```dart
// Glassmorphism implementation
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.08),
          theme.primary.withOpacity(0.05),
        ],
      ),
      border: Border.all(
        color: theme.primary.withOpacity(0.2),
      ),
      borderRadius: BorderRadius.circular(24),
    ),
  ),
)
```

---

**🎯 Résultat attendu :** Onboarding qui marque les esprits dès la première seconde, différenciation Coach/Client immédiate et mémorable, navigation intuitive malgré les effets visuels spectaculaires.