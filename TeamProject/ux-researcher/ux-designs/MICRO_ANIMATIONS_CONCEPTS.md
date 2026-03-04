# MyCoach — Micro-Animations & Transitions Fluides 🎬

> **Vision :** Interactions naturelles qui donnent vie à l'interface, transitions cinématiques, feedback satisfaisant  
> **Références :** Apple iOS fluidity, Tesla Model S transitions, Adobe Fresco interactions, Figma Smart Animate

---

## 🎭 Animation Principles

### Design Philosophy
```
NATURAL MOTION LAWS:
- Easing: cubic-bezier(0.25, 0.46, 0.45, 0.94) "easeOutQuad"
- Duration scaling: 200ms (micro), 300ms (standard), 500ms (complex)
- Choreography: Staggered entrances, synchronized exits
- Purposeful animation: Every animation has functional purpose

EMOTIONAL IMPACT:
- Confidence (Coach): Strong, direct, precise motions
- Motivation (Client): Bouncy, celebratory, energetic motions  
- Brand consistency: Glass effects always smooth, glows always soft
- Performance: 60fps guaranteed, graceful degradation on older devices
```

---

## ⚡ Core Animation Library

### 1. Glass Emergence System
```css
/* Glass Card Entry */
@keyframes glassEmerge {
  0% {
    opacity: 0;
    transform: translateY(30px) scale(0.95);
    backdrop-filter: blur(0px);
    background: transparent;
  }
  50% {
    opacity: 0.7;
    backdrop-filter: blur(10px);
  }
  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
    backdrop-filter: blur(var(--glass-blur));
    background: var(--glass-background);
  }
}

/* Usage */
.glass-card {
  animation: glassEmerge 400ms var(--ease-out-quad) forwards;
}
```

### 2. Glow Pulse System
```css
/* Heartbeat Glow for Active Elements */
@keyframes glowHeartbeat {
  0%, 100% {
    box-shadow: 0 0 20px var(--glow-color);
    transform: scale(1);
  }
  50% {
    box-shadow: 
      0 0 30px var(--glow-color),
      0 0 40px var(--glow-color);
    transform: scale(1.02);
  }
}

/* Notification Glow */
@keyframes glowNotification {
  0% { box-shadow: 0 0 0px var(--alert-color); }
  50% { box-shadow: 0 0 25px var(--alert-color); }
  100% { box-shadow: 0 0 0px var(--alert-color); }
}
```

### 3. Floating Motion System
```css
/* Gentle Float for Floating Elements */
@keyframes gentleFloat {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  25% {
    transform: translateY(-8px) rotate(0.5deg);
  }
  75% {
    transform: translateY(8px) rotate(-0.5deg);
  }
}

/* Sparkle Float for Client Theme */
@keyframes sparkleFloat {
  0%, 100% {
    transform: translateY(0px) scale(1);
    opacity: 0.7;
  }
  50% {
    transform: translateY(-15px) scale(1.2);
    opacity: 1;
  }
}
```

---

## 🎪 Transition Choreography

### Page Navigation Transitions

#### Coach Theme: Cyber Slide
```css
/* Outgoing Page */
@keyframes coachPageExit {
  0% {
    transform: translateX(0) scale(1);
    opacity: 1;
    filter: blur(0px);
  }
  100% {
    transform: translateX(-100px) scale(0.95);
    opacity: 0;
    filter: blur(5px);
  }
}

/* Incoming Page */
@keyframes coachPageEnter {
  0% {
    transform: translateX(100px) scale(0.95);
    opacity: 0;
    filter: blur(5px);
  }
  100% {
    transform: translateX(0) scale(1);
    opacity: 1;
    filter: blur(0px);
  }
}

/* Glass overlay during transition */
@keyframes transitionGlass {
  0%, 100% { backdrop-filter: blur(0px); }
  50% { backdrop-filter: blur(20px); }
}
```

#### Client Theme: Bouncy Morph
```css
/* Outgoing Page */
@keyframes clientPageExit {
  0% {
    transform: scale(1) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: scale(0.8) rotate(-5deg);
    opacity: 0;
  }
}

/* Incoming Page */
@keyframes clientPageEnter {
  0% {
    transform: scale(1.2) rotate(5deg);
    opacity: 0;
  }
  60% {
    transform: scale(0.95) rotate(-1deg);
    opacity: 0.9;
  }
  100% {
    transform: scale(1) rotate(0deg);
    opacity: 1;
  }
}
```

### Modal & Sheet Animations

#### Bottom Sheet Emergence
```css
@keyframes sheetSlideUp {
  0% {
    transform: translateY(100%);
    backdrop-filter: blur(0px);
  }
  100% {
    transform: translateY(0);
    backdrop-filter: blur(15px);
  }
}

/* Sheet handle animation */
@keyframes handlePulse {
  0%, 100% {
    transform: scaleX(1);
    opacity: 0.3;
  }
  50% {
    transform: scaleX(1.2);
    opacity: 0.6;
  }
}
```

#### Dialog Glass Appearance  
```css
@keyframes dialogGlassAppear {
  0% {
    transform: scale(0.8);
    opacity: 0;
    backdrop-filter: blur(0px);
  }
  70% {
    transform: scale(1.05);
  }
  100% {
    transform: scale(1);
    opacity: 1;
    backdrop-filter: blur(25px);
  }
}
```

---

## 🎮 Interactive Micro-Animations

### Button Press Feedback

#### Glass Button (Coach Theme)
```css
.glass-button-coach {
  transition: all 200ms var(--ease-out-quad);
}

.glass-button-coach:active {
  transform: scale(0.95);
  background: linear-gradient(135deg, 
    rgba(255, 255, 255, 0.15) 0%,
    rgba(255, 107, 53, 0.1) 100%);
  box-shadow: 
    inset 0 4px 8px rgba(0, 0, 0, 0.2),
    0 0 0px var(--orange-glow);
}

.glass-button-coach:hover {
  transform: scale(1.02);
  box-shadow: 
    0 0 25px var(--orange-glow),
    0 8px 32px rgba(0, 0, 0, 0.3);
}
```

#### Bouncy Button (Client Theme)  
```css
.bouncy-button-client {
  transition: all 150ms var(--ease-out-quad);
}

.bouncy-button-client:active {
  animation: buttonBounce 300ms var(--ease-out-quad);
}

@keyframes buttonBounce {
  0% { transform: scale(1); }
  50% { transform: scale(0.9); }
  70% { transform: scale(1.05); }
  100% { transform: scale(1); }
}
```

### Card Hover Effects

#### Data Card Hover (Coach)
```css
.data-card-coach {
  transition: all 300ms var(--ease-out-quad);
  transform-style: preserve-3d;
}

.data-card-coach:hover {
  transform: translateY(-8px) rotateX(5deg);
  box-shadow: 
    0 20px 40px rgba(0, 0, 0, 0.4),
    0 0 30px var(--orange-glow);
}

.data-card-coach:hover .card-content {
  animation: cardContentFloat 600ms var(--ease-out-quad);
}

@keyframes cardContentFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-4px); }
}
```

#### Progress Card (Client)
```css
.progress-card-client:hover {
  animation: progressCardShimmer 800ms var(--ease-out-quad);
}

@keyframes progressCardShimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

.progress-card-client {
  background: linear-gradient(
    90deg,
    transparent,
    rgba(0, 210, 255, 0.1) 50%,
    transparent
  );
  background-size: 200% 100%;
}
```

---

## 📊 Data Visualization Animations

### Chart Drawing Animations

#### Line Chart Draw
```css
@keyframes lineChartDraw {
  0% {
    stroke-dasharray: 0 1000;
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    stroke-dasharray: 1000 0;
    opacity: 1;
  }
}

/* Data points appear after line */
@keyframes dataPointPop {
  0% {
    transform: scale(0);
    opacity: 0;
  }
  50% {
    transform: scale(1.2);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}
```

#### Progress Bar Fill
```css
@keyframes progressFill {
  0% {
    width: 0%;
    background-position: -200% 0;
  }
  100% {
    width: var(--target-width);
    background-position: 200% 0;
  }
}

.progress-bar {
  background: linear-gradient(
    90deg,
    var(--progress-color),
    var(--progress-highlight),
    var(--progress-color)
  );
  background-size: 200% 100%;
  animation: progressFill 1200ms var(--ease-out-quad) forwards;
}
```

### Number Counter Animation
```css
/* JavaScript-driven number counting with CSS support */
.counter-number {
  font-variant-numeric: tabular-nums;
  transition: all 300ms var(--ease-out-quad);
}

.counter-number.updating {
  animation: numberPulse 500ms var(--ease-out-quad);
}

@keyframes numberPulse {
  0%, 100% {
    transform: scale(1);
    color: var(--text-primary);
  }
  50% {
    transform: scale(1.1);
    color: var(--accent-primary);
    text-shadow: 0 0 10px var(--accent-primary);
  }
}
```

---

## 🎊 Celebration Animations

### Achievement Unlock

#### Confetti Burst System
```css
@keyframes confettiFall {
  0% {
    transform: translateY(-100vh) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: translateY(100vh) rotate(720deg);
    opacity: 0;
  }
}

.confetti-particle {
  position: fixed;
  width: 8px;
  height: 8px;
  background: var(--confetti-color);
  animation: confettiFall var(--fall-duration) var(--fall-delay) ease-in forwards;
}

/* Sparkle burst from achievement */
@keyframes sparkleBurst {
  0% {
    transform: scale(0) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: scale(1) rotate(180deg);
    opacity: 0;
  }
}
```

#### Trophy Presentation
```css
@keyframes trophyPresent {
  0% {
    transform: scale(0) translateY(50px) rotate(-45deg);
    opacity: 0;
  }
  50% {
    transform: scale(1.2) translateY(-10px) rotate(5deg);
    opacity: 1;
  }
  100% {
    transform: scale(1) translateY(0) rotate(0deg);
    opacity: 1;
  }
}

.trophy-icon {
  animation: trophyPresent 800ms var(--ease-out-quad) forwards;
}
```

### Streak Fire Effect
```css
@keyframes fireFlicker {
  0%, 100% {
    transform: scale(1) rotate(0deg);
    filter: hue-rotate(0deg);
  }
  25% {
    transform: scale(1.1) rotate(2deg);
    filter: hue-rotate(10deg);
  }
  75% {
    transform: scale(0.9) rotate(-2deg);
    filter: hue-rotate(-10deg);
  }
}

.streak-fire {
  animation: fireFlicker 1500ms ease-in-out infinite;
}

/* Fire particles */
@keyframes fireParticle {
  0% {
    transform: translateY(0) scale(1);
    opacity: 0.8;
  }
  100% {
    transform: translateY(-30px) scale(0);
    opacity: 0;
  }
}
```

---

## 🌊 Loading & State Transitions

### Shimmer Loading System

#### Rainbow Shimmer (Client)
```css
@keyframes rainbowShimmer {
  0% {
    background-position: -200% 0;
    filter: hue-rotate(0deg);
  }
  100% {
    background-position: 200% 0;
    filter: hue-rotate(360deg);
  }
}

.shimmer-rainbow {
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.4) 50%,
    transparent
  );
  background-size: 200% 100%;
  animation: rainbowShimmer 1500ms ease-in-out infinite;
}
```

#### Tech Shimmer (Coach)
```css
@keyframes techShimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

.shimmer-tech {
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 107, 53, 0.3) 50%,
    transparent
  );
  background-size: 200% 100%;
  animation: techShimmer 1200ms ease-in-out infinite;
}
```

### Pull-to-Refresh
```css
@keyframes pullIndicator {
  0% {
    transform: rotate(0deg) scale(0.8);
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    transform: rotate(180deg) scale(1);
    opacity: 1;
  }
}

.pull-indicator {
  animation: pullIndicator 300ms var(--ease-out-quad) forwards;
}

/* Refresh completion */
@keyframes refreshComplete {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.2);
    opacity: 0.7;
  }
  100% {
    transform: scale(0);
    opacity: 0;
  }
}
```

---

## 🎯 Flutter Implementation

### Animation Controllers Setup
```dart
class MyCoachAnimations {
  // Duration constants
  static const Duration microDuration = Duration(milliseconds: 200);
  static const Duration standardDuration = Duration(milliseconds: 300);
  static const Duration complexDuration = Duration(milliseconds: 500);
  
  // Curve constants
  static const Curve easeOutQuad = Curves.easeOutQuart;
  static const Curve easeOutBack = Curves.easeOutBack;
  static const Curve elasticOut = Curves.elasticOut;
  
  // Glass emergence animation
  static Animation<double> createGlassEmergence(
    AnimationController controller,
  ) {
    return CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 1.0, curve: easeOutQuad),
    );
  }
  
  // Button press feedback
  static Animation<double> createButtonPress(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }
}
```

### Glassmorphism Animation Widget
```dart
class AnimatedGlassCard extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool animate;
  
  const AnimatedGlassCard({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.animate = true,
  }) : super(key: key);

  @override
  _AnimatedGlassCardState createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<AnimatedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: MyCoachAnimations.easeOutQuad,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8),
    ));
    
    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0),
    ));
    
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
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
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Celebration Animation Widget
```dart
class CelebrationAnimation extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const CelebrationAnimation({Key? key, this.onComplete}) : super(key: key);

  @override
  _CelebrationAnimationState createState() => _CelebrationAnimationState();
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _trophyController;
  
  @override
  void initState() {
    super.initState();
    
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _startCelebration();
  }
  
  void _startCelebration() async {
    await _trophyController.forward();
    _confettiController.forward();
    
    await Future.delayed(const Duration(milliseconds: 2000));
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Trophy animation
        Center(
          child: AnimatedBuilder(
            animation: _trophyController,
            builder: (context, child) {
              return Transform.scale(
                scale: Curves.elasticOut.transform(_trophyController.value),
                child: Icon(
                  Icons.emoji_events,
                  size: 100,
                  color: Colors.amber.withOpacity(_trophyController.value),
                ),
              );
            },
          ),
        ),
        
        // Confetti particles
        ...List.generate(50, (index) => ConfettiParticle(
          animation: _confettiController,
          index: index,
        )),
      ],
    );
  }
}
```

---

**🎯 Résultat :** Système d'animations cohérent et performant qui renforce l'identité visuelle, améliore l'UX par le feedback tactile, et crée des moments mémorables lors des interactions clés.**