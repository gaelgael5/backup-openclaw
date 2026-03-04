# MyCoach — Design System Ultra-Moderne 2026 ⚡

> **Vision :** Interface futuriste qui fait WOW, différenciation Coach/Client, glassmorphism + néon  
> **Inspiration :** Apple Vision Pro, Tesla UI, Nike Training Club, Strava, Mirror Fitness  
> **Tendances :** Glassmorphism, Néomorphisme, Gradients néon, Dark mode premium

---

## 🎨 Brand Identity 2026

### Positionnement Visual
- **Coach Interface** : Dark tech premium, vibes cyber, contrôle/puissance ⚡
- **Client Interface** : Light dynamique, motivation, gaming/achievements 🚀
- **Cohérence** : Même ADN mais expériences différenciées

---

## 🌈 Color Palette

### 🔥 Coach Theme (Dark Premium)
```
Background Primary   : #0A0A0F    (Deep space)
Background Secondary : #12121A    (Card backgrounds)
Background Tertiary  : #1A1A24    (Elevated surfaces)
Background Glass     : #FFFFFF08  (Glassmorphism overlay)

Text Primary         : #FFFFFF    (Pure white)
Text Secondary       : #B8B8CC    (Muted white)
Text Tertiary        : #6B6B7A    (Disabled text)

Accent Primary       : #FF6B35    (Electric orange/red)
Accent Secondary     : #8B5CF6    (Electric purple)
Accent Tertiary      : #06FFA5    (Electric green/cyan)

Neon Glow           : #FF6B35AA  (Orange glow)
Neon Purple         : #8B5CF6AA  (Purple glow)
Neon Cyan           : #06FFA5AA  (Cyan glow)

Glass Border        : #FFFFFF15  (Glass edges)
Glass Highlight     : #FFFFFF25  (Glass reflections)
```

### ✨ Client Theme (Light Dynamic)
```
Background Primary   : #F8FAFF    (Ultra light blue)
Background Secondary : #FFFFFF    (Pure white)
Background Tertiary  : #F0F4FF    (Light blue tint)
Background Glass     : #FFFFFF80  (Light glassmorphism)

Text Primary         : #0F0F23    (Deep dark)
Text Secondary       : #4A4A5A    (Medium gray)
Text Tertiary        : #9090A0    (Light gray)

Accent Primary       : #00D2FF    (Electric cyan)
Accent Secondary     : #FF4081    (Electric pink)
Accent Tertiary      : #7B68EE    (Electric blue)

Neon Glow           : #00D2FFAA  (Cyan glow)
Neon Pink           : #FF4081AA  (Pink glow)
Neon Blue           : #7B68EEAA  (Blue glow)

Glass Border        : #00D2FF20  (Cyan glass edge)
Glass Highlight     : #FFFFFF40  (White reflection)
```

---

## 🎯 Glassmorphism System

### Glass Card Components
```css
/* Coach Glass Card */
background: linear-gradient(135deg, 
  rgba(255, 255, 255, 0.08) 0%,
  rgba(255, 255, 255, 0.02) 100%
);
backdrop-filter: blur(20px);
border: 1px solid rgba(255, 255, 255, 0.15);
box-shadow: 
  0 8px 32px rgba(0, 0, 0, 0.3),
  inset 0 1px 0 rgba(255, 255, 255, 0.25);
border-radius: 16px;

/* Client Glass Card */
background: linear-gradient(135deg,
  rgba(255, 255, 255, 0.5) 0%,
  rgba(255, 255, 255, 0.2) 100%
);
backdrop-filter: blur(15px);
border: 1px solid rgba(0, 210, 255, 0.2);
box-shadow:
  0 8px 32px rgba(0, 210, 255, 0.15),
  inset 0 1px 0 rgba(255, 255, 255, 0.4);
```

### Glass Hierarchy
- **Level 1** : Background (blur 40px, opacity 0.05)
- **Level 2** : Cards (blur 20px, opacity 0.08)
- **Level 3** : Buttons (blur 15px, opacity 0.12)
- **Level 4** : Floating elements (blur 10px, opacity 0.15)

---

## ⚡ Neon & Glow Effects

### Glow Presets
```css
/* Coach Orange Glow */
.glow-orange {
  box-shadow: 
    0 0 20px #FF6B35AA,
    0 0 40px #FF6B3555,
    0 0 60px #FF6B3522;
}

/* Client Cyan Glow */
.glow-cyan {
  box-shadow:
    0 0 20px #00D2FFAA,
    0 0 40px #00D2FF55,
    0 0 60px #00D2FF22;
}

/* Purple Accent */
.glow-purple {
  box-shadow:
    0 0 15px #8B5CF6AA,
    0 0 30px #8B5CF655;
}
```

### Neon Typography
- **Headlines** : Glow effects sur titres principaux
- **CTAs** : Pulsing glow animation
- **Status indicators** : Static glow selon état

---

## 📝 Typography 2026

### Font Stack
```
Primary: "SF Pro Display", "Inter", system-ui
Secondary: "SF Pro Text", "Inter", system-ui
Mono: "SF Mono", "Fira Code", monospace
```

### Type Scale (Coach)
```
Hero Display    : 48px/56px, Weight 900, Letter -2%
Title XL        : 32px/40px, Weight 800, Letter -1%
Title L         : 24px/32px, Weight 700, Letter -0.5%
Title M         : 20px/28px, Weight 700, Letter 0%
Title S         : 16px/24px, Weight 600, Letter 0%
Body L          : 16px/24px, Weight 400, Letter 0%
Body M          : 14px/20px, Weight 400, Letter 0%
Body S          : 12px/16px, Weight 400, Letter 0.5%
Caption         : 10px/12px, Weight 500, Letter 1%
```

### Type Scale (Client)
```
Hero Display    : 44px/52px, Weight 800, Letter -1.5%
Title XL        : 28px/36px, Weight 700, Letter -1%
Title L         : 22px/30px, Weight 600, Letter -0.5%
Title M         : 18px/26px, Weight 600, Letter 0%
Title S         : 15px/22px, Weight 500, Letter 0%
Body L          : 15px/22px, Weight 400, Letter 0%
Body M          : 13px/18px, Weight 400, Letter 0%
Body S          : 11px/14px, Weight 400, Letter 0.5%
Caption         : 9px/11px, Weight 500, Letter 1%
```

---

## 🎬 Motion Design

### Animation Principles
- **Easing** : `cubic-bezier(0.23, 1, 0.320, 1)` (easeOutQuint)
- **Duration** : 200ms (micro), 400ms (standard), 600ms (complex)
- **Choreography** : Staggered entrances, fluid exits

### Signature Animations
```css
/* Glass Surface Entry */
@keyframes glassAppear {
  0% {
    opacity: 0;
    backdrop-filter: blur(0px);
    transform: scale(0.9) translateY(20px);
  }
  100% {
    opacity: 1;
    backdrop-filter: blur(20px);
    transform: scale(1) translateY(0);
  }
}

/* Neon Pulse */
@keyframes neonPulse {
  0%, 100% {
    box-shadow: 0 0 20px var(--neon-color);
  }
  50% {
    box-shadow: 0 0 30px var(--neon-color),
                0 0 40px var(--neon-color);
  }
}

/* Float Animation */
@keyframes floatGlass {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-8px); }
}
```

### Micro-interactions
- **Button hover** : Scale 1.05 + glow intensify
- **Card tap** : Scale 0.98 + glassmorphism intensify  
- **Input focus** : Border glow + backdrop blur increase
- **List scroll** : Parallax glass layers
- **Status changes** : Morphing neon effects

---

## 🧩 Component Library

### Glass Buttons
```
Primary CTA (Coach):
- Background: Glass gradient + orange glow
- Hover: Scale + intensify glow
- Active: Scale down + glass compression

Primary CTA (Client):
- Background: Glass gradient + cyan glow
- Hover: Scale + intensify glow + slight rotation
- Active: Scale + glass shimmer effect
```

### Navigation
```
Coach Bottom Nav:
- Background: Deep glass (#0A0A0F + blur)
- Active icons: Orange glow + size increase
- Inactive: Glass opacity 60%

Client Bottom Nav:
- Background: Light glass (#FFFFFF + blur)
- Active icons: Cyan glow + bounce animation
- Inactive: Glass opacity 40%
```

### Cards & Surfaces
```
Coach Data Cards:
- Glass morphism level 2
- Orange accent borders on hover
- Floating shadow animation
- Subtle parallax on scroll

Client Content Cards:
- Glass morphism level 2  
- Cyan accent highlights
- Gentle bounce on interaction
- Color shifting backgrounds
```

---

## 📱 Responsive Breakpoints

### Mobile First (320px - 767px)
- Glass blur: 15px (performance)
- Simplified glow effects
- Touch-friendly sizing (min 48px)
- Reduced motion for accessibility

### Tablet (768px - 1023px)
- Glass blur: 20px
- Full glow effects
- Grid layouts
- Enhanced micro-interactions

### Desktop (1024px+)
- Glass blur: 25px
- Maximum visual effects
- Hover states
- Complex animations

---

## 🎯 Differentiation Strategy

### Coach Experience (Power User)
- **Visual Language** : Cyber/tech, commanding, analytical
- **Interactions** : Direct, efficient, professional
- **Cognitive Load** : Higher information density OK
- **Status Indicators** : Precise, data-driven

### Client Experience (Consumer)
- **Visual Language** : Friendly, motivational, lifestyle
- **Interactions** : Guided, encouraging, gamified
- **Cognitive Load** : Simplified, intuitive
- **Status Indicators** : Visual progress, achievements

### Shared DNA
- **Glassmorphism** : Same technique, different opacity/blur
- **Color Psychology** : Complementary but distinct palettes
- **Animation Timing** : Consistent easing functions
- **Typography** : Same families, different scales

---

## 🚀 Implementation Notes

### CSS Variables Setup
```css
/* Coach Theme */
:root[data-theme="coach"] {
  --bg-primary: #0A0A0F;
  --bg-glass: #FFFFFF08;
  --accent-primary: #FF6B35;
  --glow-primary: #FF6B35AA;
  --glass-blur: 20px;
  --glass-opacity: 0.08;
}

/* Client Theme */
:root[data-theme="client"] {
  --bg-primary: #F8FAFF;
  --bg-glass: #FFFFFF80;
  --accent-primary: #00D2FF;
  --glow-primary: #00D2FFAA;
  --glass-blur: 15px;
  --glass-opacity: 0.5;
}
```

### Flutter Implementation
```dart
// Glassmorphism Widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final int level; // 1-4 glass hierarchy
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

---

## ✅ Validation Criteria

### Visual Impact
- [ ] Immediate "WOW" factor on first view
- [ ] Distinctive from 99% of fitness apps
- [ ] Professional yet cutting-edge
- [ ] Memorable brand differentiation

### Usability
- [ ] Accessibility contrast ratios maintained
- [ ] Intuitive navigation preserved
- [ ] Performance-optimized effects
- [ ] Cross-platform consistency

### Brand Coherence
- [ ] Coach/Client themes feel connected but distinct
- [ ] Scalable across future features
- [ ] Appeals to target demographics
- [ ] Supports business positioning

---

**🎯 Objectif :** Créer l'interface fitness la plus avancée visuellement de 2026, qui inspire confiance aux coachs et motive les clients, tout en restant utilisable et performante.