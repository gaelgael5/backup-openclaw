# MyCoach — Booking Flow Design

> Wireframes + UX flow réservation | Cohérence avec design system existant
> Stack : Flutter + Material 3 | Police : Inter | Primaire : #2563EB | Secondaire : #10B981
> Date : 2026-03-02

---

## Vue d'ensemble du flow

Le booking flow permet aux clients de réserver des créneaux avec leur coach directement dans l'app. Flow optimisé pour mobile-first avec confirmation en 3 étapes maximum.

### User Journey
```
Client Dashboard → Réserver une séance → Calendrier coach → Sélection créneau → Confirmation → Confirmé
     ↓                    ↓                    ↓               ↓              ↓            ↓
   Entry point        Choose service     Available slots    Review booking    Payment    Success
```

---

## Écran 1 — Sélection Service/Coach (Entry Point)

### Context d'accès
- Depuis Dashboard Client : Card "Prochaine séance" avec bouton "Réserver"
- Depuis Programmes : bouton "Réserver avec mon coach"
- Depuis Chat : bouton action "Planifier séance"

### Layout
```
[AppBar] bg:#FFFFFF elevation:0
  title: "Réserver une séance" headlineMedium 24sp Bold #0F172A
  leading: Icons.arrow_back_ios_new 20dp #0F172A

[Body scroll] padding:16dp h, 24dp v

[Section Coach assigné] (si mono-coach)
  Card bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
    Row:
      CircleAvatar r:28dp photo coach
      SizedBox w:12dp
      Column start:
        "Sarah Martin" titleMedium 16sp SemiBold #0F172A
        "Coach fitness certifié" bodySmall 12sp #64748B
        Row: Icons.star_rounded 14dp #F59E0B + "4.8" labelSmall 10sp 600 #F59E0B + "(127 avis)"
      Spacer
      Icons.verified 20dp #10B981

[SizedBox h:24dp]

[Section Types de séance]
  "Type de séance" titleMedium 16sp SemiBold #0F172A
  SizedBox h:12dp
  
  ServiceCard répétée:
    Container mb:12dp padding:16dp bg:#FFFFFF radiusMd border:#F1F5F9
    border:2dp #2563EB si sélectionnée
    Row:
      Container 48×48dp bg:#DBEAFE radiusMd
        Icons.fitness_center 24dp #2563EB (icône selon type)
      SizedBox w:12dp
      Expanded Column start:
        "Séance individuelle" titleMedium 16sp SemiBold #0F172A
        "Coaching personnalisé 1:1" bodyMedium 14sp #64748B
        Row: "60 min" labelSmall 10sp 600 #2563EB + SizedBox w:8dp + "À partir de 50€" bodySmall #64748B
    
  Types disponibles:
  1. Séance individuelle (Icons.person) - Coaching 1:1 personnalisé
  2. Évaluation physique (Icons.assessment) - Bilan et tests
  3. Consultation nutrition (Icons.restaurant) - Conseils alimentaires
  4. Séance découverte (Icons.explore) - Première séance gratuite

[SizedBox h:32dp]

[ContinueButton]
  FilledButton "Voir les créneaux disponibles" 
  width:∞ height:52dp bg:#2563EB fg:#FFFFFF
  disabled si aucune sélection → bg:#CBD5E1 fg:#64748B
  radiusMd elevation:0
```

### États
- **Chargement** : shimmer cards
- **Erreur** : Icons.error_outline 24dp #EF4444 + message + TextButton "Réessayer"
- **Aucun service** : état vide avec illustration + "Contactez votre coach"

---

## Écran 2 — Calendrier & Créneaux Disponibles

### Layout
```
[AppBar] bg:#FFFFFF elevation:0
  title: "Choisir un créneau" headlineMedium 24sp Bold #0F172A
  leading: Icons.arrow_back_ios_new 20dp #0F172A

[Header service sélectionné] bg:#F8FAFC padding:16dp
  Row:
    Container 36×36dp bg:#DBEAFE radiusSm Icons.person 18dp #2563EB
    SizedBox w:12dp
    Column start:
      "Séance individuelle" bodyLarge 16sp 600 #0F172A
      "60 min • À partir de 50€" bodySmall 12sp #64748B

[SizedBox h:16dp]

[Sélecteur de mois] padding:16dp h
  Row spaceBetween:
    IconButton Icons.chevron_left 24dp #64748B
    "Mars 2026" titleLarge 20sp SemiBold #0F172A
    IconButton Icons.chevron_right 24dp #64748B

[Calendrier compact] padding:16dp h
  GridView 7 colonnes (L M M J V S D)
  Header jours: labelMedium 12sp 600 #64748B center
  
  Cases jours:
    Container 40×40dp radiusSm
    - Aujourd'hui: border:2dp #2563EB
    - Disponible: bg:#FFFFFF, onTap: sélection
    - Occupé: bg:#F1F5F9 text:#94A3B8
    - Sélectionné: bg:#2563EB text:#FFFFFF
    - Passé: text:#CBD5E1

[SizedBox h:24dp]

[Créneaux du jour sélectionné]
  "Créneaux disponibles - Mardi 4 mars" titleMedium 16sp SemiBold #0F172A
  SizedBox h:12dp
  
  GridView 2 colonnes, gap:12dp
  SlotCard:
    Container h:56dp padding:12dp bg:#FFFFFF radiusMd border:#F1F5F9
    border:2dp #2563EB si sélectionné
    Column center:
      "14:00" titleMedium 16sp SemiBold #0F172A
      "Disponible" bodySmall 12sp #10B981
    
    États slot:
    - Disponible: border:#F1F5F9 text "Disponible" #10B981
    - Bientôt plein: border:#F59E0B text "Plus que 2 places" #F59E0B
    - Complet: bg:#F1F5F9 text "Complet" #94A3B8 non cliquable
    - Sélectionné: border:#2563EB bg:#DBEAFE text "Sélectionné" #2563EB

[SizedBox h:100dp clearance]

[Bottom action] fixed bg:#FFFFFF border-top:#F1F5F9 padding:16dp + safe area
  FilledButton "Continuer" width:∞ height:52dp bg:#2563EB
  disabled si aucun slot sélectionné
```

### Interactions
- Swipe horizontal sur calendrier → mois suivant/précédent
- Tap jour → affiche créneaux disponibles
- Tap créneau disponible → sélection + feedback haptic
- Long press créneau → preview détails coach dans BottomSheet

### États spéciaux
- **Aucun créneau dispo** : Icons.event_busy 48dp #CBD5E1 + "Aucun créneau libre ce jour" + TextButton "Proposer d'autres dates"
- **Chargement créneaux** : shimmer slots
- **Erreur réseau** : retry avec SnackBar

---

## Écran 3 — Récapitulatif & Confirmation

### Layout
```
[AppBar] bg:#FFFFFF elevation:0
  title: "Confirmation" headlineMedium 24sp Bold #0F172A
  leading: Icons.arrow_back_ios_new 20dp #0F172A

[Body scroll] padding:16dp h, 24dp v

[Card Résumé] bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
  "Résumé de la réservation" titleMedium 16sp SemiBold #0F172A
  SizedBox h:16dp
  
  Rows avec Divider indent:0 #F1F5F9:
    Icons.event_outlined 20dp #64748B + "Mardi 4 mars 2026, 14:00" bodyMedium #0F172A
    Icons.schedule_outlined 20dp #64748B + "60 minutes" bodyMedium #0F172A  
    Icons.person_outlined 20dp #64748B + "Sarah Martin" bodyMedium #0F172A
    Icons.fitness_center_outlined 20dp #64748B + "Séance individuelle" bodyMedium #0F172A
    Icons.location_on_outlined 20dp #64748B + "Studio MyCoach - Paris 11e" bodyMedium #0F172A

[SizedBox h:24dp]

[Card Prix] bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
  "Détail du prix" titleMedium 16sp SemiBold #0F172A
  SizedBox h:16dp
  
  Row spaceBetween: "Séance individuelle" bodyMedium #64748B + "50,00 €" bodyMedium #0F172A
  SizedBox h:8dp
  Row spaceBetween: "Frais de service" bodyMedium #64748B + "2,50 €" bodyMedium #0F172A
  Divider #F1F5F9
  Row spaceBetween: "Total" titleMedium 16sp SemiBold #0F172A + "52,50 €" titleMedium 16sp Bold #2563EB

[SizedBox h:24dp]

[Card Paiement] bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
  "Méthode de paiement" titleMedium 16sp SemiBold #0F172A
  SizedBox h:16dp
  
  PaymentMethodTile sélectionnable:
    Container padding:12dp border:2dp radiusMd
    border:#F1F5F9 normal, #2563EB sélectionné
    Row:
      Icons.credit_card 24dp #64748B
      SizedBox w:12dp
      Column start: "**** 1234" bodyMedium 600 #0F172A + "Expire 12/28" bodySmall #64748B
      Spacer
      Radio activeColor:#2563EB
  
  TextButton.icon "+ Ajouter une carte" Icons.add labelMedium #2563EB

[SizedBox h:24dp]

[Card Conditions] bg:#F8FAFC radiusMd padding:16dp
  Icons.info_outline 20dp #64748B + "Annulation gratuite jusqu'à 24h avant" bodySmall #64748B
  SizedBox h:8dp
  TextButton "Conditions d'annulation" labelMedium #2563EB

[SizedBox h:100dp clearance]

[Bottom Actions] fixed bg:#FFFFFF border-top:#F1F5F9 padding:16dp + safe area
  FilledButton "Confirmer et payer" 
  width:∞ height:52dp bg:#2563EB fg:#FFFFFF
  Icons.payment 20dp + "Payer 52,50 €" labelLarge 14sp SemiBold
```

### États
- **Processing payment** : bouton affiche CircularProgressIndicator 20×20 blanc, disabled
- **Erreur paiement** : SnackBar rouge + shake animation bouton
- **Succès** : navigation vers écran confirmation + SnackBar vert

---

## Écran 4 — Confirmation Réussie

### Layout
```
[AppBar] bg:#FFFFFF elevation:0 automaticallyImplyLeading:false
  title: "Réservation confirmée" headlineMedium 24sp Bold #0F172A
  actions: Icons.close 24dp #0F172A → pop to dashboard

[Body] padding:24dp center Column

[Succès Illustration] 
  Container 120×120dp bg:#D1FAE5 circle
    Icons.check_circle 64dp #10B981

[SizedBox h:24dp]

[Text "Réservation confirmée !"] headlineMedium 24sp Bold #0F172A center
[SizedBox h:8dp]
[Text "Vous recevrez une notification de rappel 1h avant votre séance."] 
bodyMedium 14sp #64748B center maxLines:2

[SizedBox h:32dp]

[Card Détails séance] bg:#FFFFFF radiusMd border:#F1F5F9 padding:20dp
  "Votre séance" titleMedium 16sp SemiBold #0F172A center
  SizedBox h:16dp
  
  Column center:
    "Mardi 4 mars 2026" bodyLarge 16sp 600 #0F172A
    "14:00 - 15:00" titleLarge 20sp Bold #2563EB
    SizedBox h:12dp
    "Avec Sarah Martin" bodyMedium #64748B
    "Séance individuelle" bodyMedium #64748B

[SizedBox h:24dp]

[Actions rapides] Column gap:12dp
  OutlinedButton.icon "Ajouter au calendrier" 
  Icons.event_available 20dp width:∞ height:48dp
  border:#CBD5E1 radiusMd labelLarge #2563EB
  
  OutlinedButton.icon "Contacter mon coach"
  Icons.chat_bubble_outline 20dp même style
  
  TextButton "Voir mes réservations" labelMedium #64748B

[Spacer]

[FilledButton "Retour au tableau de bord"]
width:∞ height:52dp bg:#2563EB radiusMd
```

### États post-confirmation
- **Email/SMS** envoyés automatiquement avec détails + lien annulation
- **Notification push** programmée 1h avant
- **Sync calendrier** si permission accordée
- **Analytics** : tracking "booking_completed"

---

## Flow UX complet

### Étapes critiques
1. **Entry point friction minimal** : 1 tap depuis dashboard
2. **Service selection** : visuels clairs, prix visible
3. **Calendar native-like** : patterns familiers iOS/Android
4. **Instant feedback** : sélections visuelles immédiates
5. **Trust signals** : avis coach, conditions claires, sécurité paiement
6. **Confirmation satisfaisante** : sentiment d'accomplissement

### Optimisations mobiles
- **Thumb zones** : actions principales dans zone facile d'accès
- **Scroll minimal** : max 1.5 écrans de scroll par page
- **Touch targets** : minimum 48×48dp selon Material guidelines
- **Loading states** : feedback immédiat sur chaque action
- **Error recovery** : messages clairs + actions correctives

### Microfeedbacks
- **Haptic** : vibration légère sur sélection créneau
- **Animation** : scale 0.95→1.0 sur tap cards (100ms)
- **Progress** : stepper discret en haut (1/3, 2/3, 3/3)
- **Transitions** : slide horizontal entre étapes (300ms easeInOutCubic)

### Cas d'erreur gérés
- **Pas de réseau** : mode offline avec retry automatique
- **Créneau pris pendant booking** : proposition d'alternatives
- **Échec paiement** : retry + contact support
- **Session expirée** : reconnexion transparente
- **Coach indisponible** : notification + proposition de report

---

## Intégration avec dev backend

### API endpoints requis
```
GET /coaches/{id}/availability?date=YYYY-MM-DD
POST /bookings/create
GET /services/types
POST /payments/process
PUT /bookings/{id}/cancel
```

### States management Flutter
- **BlocBuilder** pour états loading/success/error
- **Form validation** temps réel avec debouncing
- **Cache** créneaux récents pour UX fluide
- **Optimistic UI** sur sélections avant confirmation API

### Notifications push
- **1h avant** : "N'oubliez pas votre séance avec Sarah à 14h"
- **24h avant** : "Séance demain - Vous pouvez encore annuler gratuitement"
- **Confirmation** : "Réservation confirmée ! Sarah vous attend mardi 4 mars à 14h"

---

## Métriques de succès

### UX Metrics
- **Taux de completion** booking flow : >85%
- **Abandon rate** par étape : <10% par step
- **Time to book** : <2 minutes médiane
- **User satisfaction** : >4.5/5 post-booking survey

### Business Metrics  
- **Conversion** calendrier → réservation : >60%
- **No-show rate** : <15%
- **Rebooking rate** : >40% dans les 30 jours
- **Revenue per booking** selon upsells

Cette conception respecte les principes Material 3 et assure une cohérence parfaite avec les 12 écrans existants du design system MyCoach.