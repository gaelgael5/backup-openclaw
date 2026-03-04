# Design System Dual — MyCoach
*Spécifications Coach Dark + Client Light*

## 🎨 Concept Dual Identity

MyCoach utilise **deux identités visuelles distinctes** pour créer des expériences utilisateur différenciées :

- **🌑 Coach Space** : Interface professionnelle, sombre, high-tech
- **🌕 Client Space** : Interface dynamique, claire, motivante

---

## 🎯 Coach Space — Dark Professional Theme

### Color Palette

#### Primaires
```css
--coach-background-primary: #0A0E1A;     /* Noir spatial profond */
--coach-background-secondary: #1A1F2E;   /* Gris anthracite */
--coach-background-tertiary: #2A2F3E;    /* Gris ardoise */

--coach-surface-elevated: #1F2937;       /* Cards élevées */
--coach-surface-glass: rgba(123, 47, 255, 0.08); /* Glassmorphism */
```

#### Accents & Actions  
```css
--coach-primary: #7B2FFF;                /* Violet électrique */
--coach-primary-hover: #9D4FFF;          
--coach-primary-pressed: #5E17CC;        

--coach-secondary: #FF6B2F;              /* Orange énergie */
--coach-secondary-hover: #FF8555;        
--coach-secondary-pressed: #CC5426;      

--coach-success: #10B981;                /* Vert néon */
--coach-warning: #F59E0B;                /* Amber électrique */
--coach-error: #EF4444;                  /* Rouge vif */
```

#### Texte & Neutrals
```css
--coach-text-primary: #FFFFFF;           /* Blanc pur */
--coach-text-secondary: #B8C4D6;         /* Gris clair */
--coach-text-tertiary: #6B7280;          /* Gris moyen */
--coach-text-disabled: #4B5563;          /* Gris foncé */

--coach-border: #374151;                 /* Bordures subtiles */
--coach-border-focus: #7B2FFF;           /* Focus électrique */
```

### Typography

#### Font Stack
```css
font-family: 'Space Grotesk', -apple-system, 'Segoe UI', sans-serif;
```

#### Scale & Weights
```css
/* Headings */
--coach-h1: 700 32px/38px 'Space Grotesk';     /* Page titles */
--coach-h2: 600 24px/30px 'Space Grotesk';     /* Section headers */  
--coach-h3: 500 20px/26px 'Space Grotesk';     /* Card titles */
--coach-h4: 500 18px/24px 'Space Grotesk';     /* Sub-headers */

/* Body Text */
--coach-body-large: 400 16px/24px 'Space Grotesk';   /* Main content */
--coach-body: 400 14px/20px 'Space Grotesk';         /* Secondary content */
--coach-body-small: 400 12px/18px 'Space Grotesk';   /* Meta info */

/* UI Text */
--coach-button: 500 16px/20px 'Space Grotesk';       /* Buttons */
--coach-caption: 400 11px/14px 'Space Grotesk';      /* Timestamps */
--coach-overline: 500 10px/12px 'Space Grotesk';     /* Labels (uppercase) */
```

### Shadows & Effects

```css
/* Depth Layers */
--coach-shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.8);
--coach-shadow-md: 0 4px 6px rgba(0, 0, 0, 0.6);
--coach-shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.5);
--coach-shadow-xl: 0 25px 50px rgba(0, 0, 0, 0.7);

/* Glassmorphism */
--coach-glass-backdrop: blur(20px) saturate(180%);
--coach-glass-border: 1px solid rgba(255, 255, 255, 0.1);

/* Glow Effects */
--coach-glow-primary: 0 0 20px rgba(123, 47, 255, 0.4);
--coach-glow-secondary: 0 0 15px rgba(255, 107, 47, 0.3);
```

---

## ☀️ Client Space — Light Dynamic Theme

### Color Palette

#### Primaires
```css
--client-background-primary: #F0F4FF;     /* Blanc bleuté doux */
--client-background-secondary: #FFFFFF;   /* Blanc pur */
--client-background-tertiary: #F8FAFC;    /* Gris très clair */

--client-surface-elevated: #FFFFFF;       /* Cards élevées */
--client-surface-tinted: rgba(0, 194, 255, 0.04); /* Teinté cyan */
```

#### Accents & Actions
```css
--client-primary: #00C2FF;               /* Cyan dynamique */
--client-primary-hover: #33D1FF;         
--client-primary-pressed: #0099CC;       

--client-secondary: #FF6B2F;             /* Orange énergie (partagé) */
--client-secondary-hover: #FF8555;       
--client-secondary-pressed: #CC5426;     

--client-success: #22C55E;               /* Vert nature */
--client-warning: #F59E0B;               /* Amber chaud */
--client-error: #EF4444;                 /* Rouge clair */
```

#### Texte & Neutrals
```css
--client-text-primary: #1A1F2E;          /* Bleu marine foncé */
--client-text-secondary: #666B78;        /* Gris bleuté */
--client-text-tertiary: #9CA3AF;         /* Gris moyen */
--client-text-disabled: #D1D5DB;         /* Gris très clair */

--client-border: #E5E7EB;                /* Bordures douces */
--client-border-focus: #00C2FF;          /* Focus cyan */
```

### Typography

#### Font Stack (identique)
```css
font-family: 'Space Grotesk', -apple-system, 'Segoe UI', sans-serif;
```

#### Scale & Weights (adaptées au contexte clair)
```css
/* Headings - Plus légers visuellement */
--client-h1: 700 32px/38px 'Space Grotesk';     
--client-h2: 600 24px/30px 'Space Grotesk';     
--client-h3: 500 20px/26px 'Space Grotesk';     
--client-h4: 500 18px/24px 'Space Grotesk';     

/* Body Text */
--client-body-large: 400 16px/24px 'Space Grotesk';  
--client-body: 400 14px/20px 'Space Grotesk';        
--client-body-small: 400 12px/18px 'Space Grotesk';  

/* UI Text */
--client-button: 500 16px/20px 'Space Grotesk';      
--client-caption: 400 11px/14px 'Space Grotesk';     
--client-overline: 500 10px/12px 'Space Grotesk';    
```

### Shadows & Effects

```css
/* Depth Layers - Plus douces */
--client-shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.06);
--client-shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
--client-shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.1);
--client-shadow-xl: 0 25px 50px rgba(0, 0, 0, 0.15);

/* Subtle Gradients */
--client-gradient-primary: linear-gradient(135deg, #00C2FF 0%, #33D1FF 100%);
--client-gradient-secondary: linear-gradient(135deg, #FF6B2F 0%, #FF8555 100%);

/* Glow Effects */
--client-glow-primary: 0 0 15px rgba(0, 194, 255, 0.2);
--client-glow-secondary: 0 0 12px rgba(255, 107, 47, 0.15);
```

---

## 🧩 Composants Partagés

### Button System

#### Coach Buttons (Dark)
```css
/* Primary */
.btn-coach-primary {
  background: var(--coach-primary);
  color: var(--coach-text-primary);
  box-shadow: var(--coach-glow-primary);
  border: none;
}

.btn-coach-primary:hover {
  background: var(--coach-primary-hover);
  transform: translateY(-1px);
  box-shadow: var(--coach-shadow-md), var(--coach-glow-primary);
}

/* Secondary */
.btn-coach-secondary {
  background: transparent;
  color: var(--coach-primary);
  border: 1px solid var(--coach-primary);
}

/* Ghost */
.btn-coach-ghost {
  background: var(--coach-surface-glass);
  color: var(--coach-text-secondary);
  border: var(--coach-glass-border);
  backdrop-filter: var(--coach-glass-backdrop);
}
```

#### Client Buttons (Light)
```css
/* Primary */
.btn-client-primary {
  background: var(--client-primary);
  color: white;
  box-shadow: var(--client-shadow-md);
  border: none;
}

.btn-client-primary:hover {
  background: var(--client-primary-hover);
  transform: translateY(-1px);
  box-shadow: var(--client-shadow-lg);
}

/* Secondary */
.btn-client-secondary {
  background: var(--client-background-secondary);
  color: var(--client-primary);
  border: 1px solid var(--client-border);
}

/* Gradient */
.btn-client-gradient {
  background: var(--client-gradient-primary);
  color: white;
  border: none;
}
```

### Card System

#### Coach Cards (Dark)
```css
.card-coach {
  background: var(--coach-background-secondary);
  border: 1px solid var(--coach-border);
  border-radius: 12px;
  box-shadow: var(--coach-shadow-md);
}

.card-coach-glass {
  background: var(--coach-surface-glass);
  border: var(--coach-glass-border);
  backdrop-filter: var(--coach-glass-backdrop);
  border-radius: 16px;
}

.card-coach-elevated {
  background: var(--coach-surface-elevated);
  box-shadow: var(--coach-shadow-lg);
  border: none;
}
```

#### Client Cards (Light)
```css
.card-client {
  background: var(--client-background-secondary);
  border: 1px solid var(--client-border);
  border-radius: 12px;
  box-shadow: var(--client-shadow-md);
}

.card-client-tinted {
  background: var(--client-surface-tinted);
  border: 1px solid rgba(0, 194, 255, 0.1);
  border-radius: 16px;
}

.card-client-elevated {
  background: var(--client-background-secondary);
  box-shadow: var(--client-shadow-lg);
  border: none;
}
```

### Form Controls

#### Input Fields
```css
/* Coach Inputs */
.input-coach {
  background: var(--coach-background-tertiary);
  border: 1px solid var(--coach-border);
  color: var(--coach-text-primary);
  border-radius: 8px;
}

.input-coach:focus {
  border-color: var(--coach-border-focus);
  box-shadow: 0 0 0 3px rgba(123, 47, 255, 0.1);
}

/* Client Inputs */
.input-client {
  background: var(--client-background-secondary);
  border: 1px solid var(--client-border);
  color: var(--client-text-primary);
  border-radius: 8px;
}

.input-client:focus {
  border-color: var(--client-border-focus);
  box-shadow: 0 0 0 3px rgba(0, 194, 255, 0.1);
}
```

---

## 🎭 States & Interactions

### Hover States
```css
/* Coach Hovers */
.coach-interactive:hover {
  transform: translateY(-2px);
  box-shadow: var(--coach-shadow-lg);
  border-color: var(--coach-primary);
}

/* Client Hovers */
.client-interactive:hover {
  transform: translateY(-1px);
  box-shadow: var(--client-shadow-lg);
  border-color: var(--client-primary);
}
```

### Loading States
```css
/* Coach Loading */
.loading-coach {
  background: linear-gradient(90deg, 
    var(--coach-background-secondary) 25%, 
    var(--coach-background-tertiary) 50%, 
    var(--coach-background-secondary) 75%
  );
  animation: shimmer-dark 1.5s infinite;
}

/* Client Loading */
.loading-client {
  background: linear-gradient(90deg, 
    var(--client-background-tertiary) 25%, 
    var(--client-border) 50%, 
    var(--client-background-tertiary) 75%
  );
  animation: shimmer-light 1.5s infinite;
}
```

---

## 📱 Responsive Behavior

### Breakpoint System (identique)
```css
/* Mobile First Approach */
.container {
  padding: 16px;
}

@media (min-width: 768px) {
  .container { padding: 24px; }
}

@media (min-width: 1024px) {
  .container { padding: 32px; }
}
```

### Navigation Adaptive
```css
/* Coach Navigation */
.nav-coach-mobile {
  background: var(--coach-background-primary);
  border-top: 1px solid var(--coach-border);
}

.nav-coach-tablet {
  background: var(--coach-background-secondary);
  border-right: 1px solid var(--coach-border);
  width: 240px;
}

/* Client Navigation */
.nav-client-mobile {
  background: var(--client-background-secondary);
  border-top: 1px solid var(--client-border);
  box-shadow: var(--client-shadow-lg);
}

.nav-client-tablet {
  background: var(--client-background-secondary);
  border-right: 1px solid var(--client-border);
  width: 240px;
}
```

---

## 🌐 Accessibilité & Conformité

### Contrast Ratios
- **Coach Space** : 4.5:1 minimum (texte sur fond sombre)
- **Client Space** : 7:1 optimal (texte foncé sur fond clair)

### Touch Targets
- Minimum : 44px × 44px
- Recommandé : 48px × 48px
- Espacement : 8px minimum entre targets

### Focus Indicators
```css
.focus-coach {
  outline: 2px solid var(--coach-primary);
  outline-offset: 2px;
}

.focus-client {
  outline: 2px solid var(--client-primary);
  outline-offset: 2px;
}
```

---

## 🔄 Animations & Transitions

### Timing Functions
```css
--ease-in-out-quart: cubic-bezier(0.77, 0, 0.175, 1);
--ease-out-expo: cubic-bezier(0.19, 1, 0.22, 1);
--ease-in-back: cubic-bezier(0.36, 0, 0.66, -0.56);
```

### Standard Transitions
```css
.transition-standard { transition: all 0.3s var(--ease-in-out-quart); }
.transition-fast { transition: all 0.15s var(--ease-out-expo); }
.transition-slow { transition: all 0.5s var(--ease-in-out-quart); }
```

### Micro-Interactions
```css
/* Button Press */
.btn-pressed {
  transform: scale(0.95);
  transition: transform 0.1s var(--ease-in-back);
}

/* Card Appear */
.card-appear {
  animation: slideUp 0.4s var(--ease-out-expo);
}

@keyframes slideUp {
  from { 
    opacity: 0; 
    transform: translateY(20px); 
  }
  to { 
    opacity: 1; 
    transform: translateY(0); 
  }
}
```