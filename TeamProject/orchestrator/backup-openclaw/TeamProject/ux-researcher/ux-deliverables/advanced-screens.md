# MyCoach — Advanced Screens Design

> Écrans avancés non couverts par les 12 maquettes existantes | MVP Features
> Stack : Flutter + Material 3 | Police : Inter | Primaire : #2563EB | Secondaire : #10B981
> Date : 2026-03-02

---

## Vue d'ensemble

Ces écrans couvrent les fonctionnalités avancées nécessaires pour le MVP, en coordination avec les développements en cours :
- **dev-flutter** : écrans clients
- **dev-python** : booking/réservation backend

---

## 1. Client Creation Form (Onboarding optimisé)

### Context
Écran pour coaches ajoutant de nouveaux clients. Optimisé pour conversion maximum et réduction des abandons.

### Layout
```
[AppBar] bg:#FFFFFF elevation:0
  title: "Ajouter un client" headlineMedium 24sp Bold #0F172A
  leading: Icons.close 24dp #0F172A → dialog if modified
  actions: TextButton "Aide" labelMedium #2563EB

[Progress indicator] LinearProgressIndicator value:0.33 h:4dp bg:#F1F5F9 color:#2563EB

[Body scroll] padding:20dp h, 24dp v

[Header motivation]
  Icons.person_add 32dp #2563EB center
  SizedBox h:12dp
  "Créons le profil de votre nouveau client" titleLarge 20sp SemiBold #0F172A center
  SizedBox h:8dp
  "Ces informations nous aideront à personnaliser son expérience" bodyMedium 14sp #64748B center

[SizedBox h:32dp]

[Section 1: Informations essentielles] 
  "Informations de base" titleMedium 16sp SemiBold #0F172A
  SizedBox h:16dp
  
  TextField prénom:
    decoration: OutlineInputBorder radiusMd
    fillColor: #F1F5F9 filled:true
    prefixIcon: Icons.person_outline 20dp #64748B
    hintText: "Prénom" hintStyle: bodyLarge #94A3B8
    contentPadding: 16dp
    border: #CBD5E1 idle, #2563EB focus, #EF4444 error
    
  SizedBox h:16dp
  
  TextField nom: // même style
  TextField email: // prefixIcon: Icons.email_outlined, keyboardType: emailAddress
  TextField téléphone: // prefixIcon: Icons.phone_outlined, keyboardType: phone
  
[SizedBox h:32dp]

[Section 2: Profil fitness]
  "Profil fitness" titleMedium 16sp SemiBold #0F172A
  SizedBox h:16dp
  
  "Niveau actuel" bodyLarge 16sp 500 #0F172A
  SizedBox h:8dp
  Row gap:8dp wrap:
    ChoiceChip "Débutant" bg:#F1F5F9 selected:#2563EB label:#64748B/#FFFFFF
    ChoiceChip "Intermédiaire" 
    ChoiceChip "Avancé"
  
  SizedBox h:16dp
  
  "Objectifs principaux (max 3)" bodyLarge 16sp 500 #0F172A
  SizedBox h:8dp
  Wrap gap:8dp:
    FilterChip "Perte de poids" Icons.trending_down 16dp
    FilterChip "Gain de muscle" Icons.fitness_center 16dp
    FilterChip "Endurance" Icons.directions_run 16dp  
    FilterChip "Flexibilité" Icons.self_improvement 16dp
    FilterChip "Bien-être" Icons.spa 16dp
    FilterChip "Sport spécifique" Icons.sports 16dp
    + chip text count "2/3 sélectionnés" si >0
  
[SizedBox h:32dp]

[Section 3: Préférences]
  "Préférences d'entraînement" titleMedium 16sp SemiBold #0F172A
  SizedBox h:16dp
  
  DropdownButtonFormField "Fréquence souhaitée":
    Items: "1x/semaine", "2x/semaine", "3x/semaine", "4x/semaine", "5+/semaine"
    decoration: même style TextField
    
  SizedBox h:16dp
  
  "Créneaux préférés" bodyLarge 16sp 500 #0F172A
  SizedBox h:8dp
  GridView 3 colonnes gap:8dp:
    TimeSlotChip "Matin (6h-10h)" selectable
    TimeSlotChip "Midi (11h-14h)"
    TimeSlotChip "Après-midi (14h-18h)"
    TimeSlotChip "Soir (18h-22h)"
    TimeSlotChip "Weekend"
    TimeSlotChip "Flexible"
    
[SizedBox h:32dp]

[Notes optionnelles]
  TextField "Notes (allergies, blessures, motivations...)" 
  maxLines:3 minLines:2 prefixIcon:Icons.note_outlined

[SizedBox h:100dp clearance]

[Bottom Actions] fixed bg:#FFFFFF border-top:#F1F5F9 padding:16dp + safe area
  Row gap:12dp:
    Expanded OutlinedButton "Brouillon" height:48dp border:#CBD5E1 text:#64748B
    Expanded FilledButton "Créer le profil" height:48dp bg:#2563EB
      disabled si prénom+nom+email vides
```

### Validation & États
- **Validation temps réel** : email format, téléphone format français
- **Sauvegarde auto** : draft toutes les 30s si modification
- **États** : loading, success (navigation + SnackBar), erreur (email existant)
- **Analytics** : tracking abandon par section, temps de completion

---

## 2. Dashboard Widgets (Stats visuelles + Quick actions)

### Context  
Widgets avancés pour le dashboard coach avec données temps réel et actions rapides.

### Widget 1: Revenus & Performance
```
Card bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
  Header Row:
    "Performance ce mois" titleMedium 16sp SemiBold #0F172A
    Spacer
    PopupMenuButton "..." → "Voir détail", "Partager", "Exporter"
    
  SizedBox h:16dp
  
  Row 2 colonnes gap:16dp:
    Column flex:2:
      "2 580 €" displayLarge 32sp 700 #10B981
      "+23% vs mois dernier" bodySmall 12sp #10B981 Icons.trending_up 14dp
      SizedBox h:12dp
      LinearProgressIndicator value:0.86 bg:#F1F5F9 color:#10B981 h:6dp radiusFull
      "86% de l'objectif mensuel" bodySmall 12sp #64748B
      
    Column flex:1:
      Container 64×64dp bg:#D1FAE5 circle center
        Icons.euro 32dp #10B981
      
  SizedBox h:16dp
  
  Row 3 métriques:
    MetricColumn flex:1:
      "28" titleLarge 20sp Bold #0F172A
      "Séances" bodySmall 12sp #64748B
    Divider vertical
    MetricColumn:  
      "12" titleLarge 20sp Bold #0F172A
      "Clients actifs" bodySmall 12sp #64748B
    Divider vertical
    MetricColumn:
      "4.8" titleLarge 20sp Bold #0F172A
      "Satisfaction" bodySmall 12sp #64748B
```

### Widget 2: Planning de la semaine
```
Card bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
  Header:
    "Planning semaine" titleMedium 16sp SemiBold #0F172A
    Spacer  
    TextButton "Voir tout" labelMedium 12sp 600 #2563EB
    
  SizedBox h:12dp
  
  TimelineWeek:
    Row jours sem (L M M J V):
      DayColumn width:1/5:
        "LUN\n4" labelSmall 10sp 600 #64748B center
        SizedBox h:8dp
        Column gap:4dp:
          SessionBlock h:32dp w:full bg:#2563EB radiusSm:
            "9h" labelSmall 10sp 600 #FFFFFF
            "Marie" labelSmall 10sp 400 #FFFFFF
          SessionBlock bg:#10B981:
            "14h" / "Paul"
          SizedBox h:16dp // = créneau libre
          SessionBlock bg:#F59E0B:
            "19h" / "Lisa"
            
  SizedBox h:12dp
  
  Row actions rapides:
    ActionChip "Créer créneau" Icons.add 16dp #2563EB bg:#F1F5F9 onTap→create
    ActionChip "Bloquer" Icons.block 16dp #EF4444 bg:#FEE2E2
```

### Widget 3: Notifications & Tâches
```
Card bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
  Header:
    "À faire" titleMedium 16sp SemiBold #0F172A
    Badge: Container padding:4dp×8dp bg:#FEE2E2 radiusFull "3" labelSmall #EF4444
    
  SizedBox h:12dp
  
  TaskList:
    TaskTile priority:high:
      Row:
        Container 8×8dp bg:#EF4444 radiusFull
        SizedBox w:8dp
        Expanded Column start:
          "Répondre à Marie (urgent)" bodyMedium 14sp 500 #0F172A
          "Il y a 2h • Changement de séance" bodySmall 12sp #64748B
        IconButton Icons.check_circle_outline 20dp #94A3B8→#10B981 onTap
        
    TaskTile priority:medium:
      bg:#F59E0B dot, "Préparer programme Paul" 
      
    TaskTile priority:low:
      bg:#2563EB dot, "Mettre à jour certifications"
      
  SizedBox h:8dp
  TextButton.icon "Voir toutes les tâches" Icons.arrow_forward labelMedium #2563EB
```

---

## 3. Chat Interface (Coach-Client Simple)

### Context
Interface de chat optimisée mobile pour communication coach-client avec partage de contenu fitness.

### Layout
```
[AppBar] bg:#FFFFFF elevation:1 shadow:soft
  leading: CircleAvatar r:16dp photo client
  title: Column start:
    "Marie Dupont" bodyLarge 16sp 600 #0F172A
    "En ligne • Répond en ~5 min" bodySmall 12sp #10B981
  actions:
    IconButton Icons.videocam_outline 22dp #64748B → video call
    IconButton Icons.more_vert 22dp #64748B → menu context

[Chat body] ListView reverse padding:12dp h, 8dp v bg:#F8FAFC

  [Bulle système - date]
    Center Container padding:8dp×12dp bg:#F1F5F9 radiusFull margin:16dp v
      "Aujourd'hui" bodySmall 12sp 500 #64748B
      
  [Message reçu]
    Align left maxWidth:85%
      Row start:
        CircleAvatar r:12dp photo client
        SizedBox w:8dp
        Flexible Container padding:12dp×16dp bg:#FFFFFF
          borderRadius: topLeft:4 topRight:16 bottomLeft:16 bottomRight:16
          shadow: #0000000A blur:4 offset:0,1
          Texte bodyMedium 14sp #0F172A lineHeight:1.4
          SizedBox h:4dp
          "14:23" bodySmall 10sp #94A3B8
          
  [Message envoyé]
    Align right maxWidth:85%
      Container padding:12dp×16dp bg:#2563EB margin:2dp b
        borderRadius: topLeft:16 topRight:4 bottomLeft:16 bottomRight:16
        Texte bodyMedium 14sp #FFFFFF lineHeight:1.4
        SizedBox h:4dp
        Row end:
          "14:25" bodySmall 10sp #FFFFFF60
          SizedBox w:4dp
          Icons.done_all 12dp #FFFFFF60 // double check = lu
          
  [Message programme partagé]
    Align right maxWidth:90%
      Card bg:#FFFFFF radiusMd border:#E2E8F0 margin:2dp b
        Container padding:0 clipBehavior:antiAlias
          Header bg:#DBEAFE padding:12dp×16dp:
            Row:
              Icons.fitness_center 20dp #2563EB
              SizedBox w:8dp
              "Programme partagé" bodyMedium 14sp 600 #2563EB
          Body padding:16dp:
            "Programme Force & Cardio" titleMedium 16sp SemiBold #0F172A
            "8 semaines • 4 séances/semaine" bodySmall 12sp #64748B
            SizedBox h:8dp
            Row:
              Container padding:4dp×8dp bg:#D1FAE5 radiusFull "Niveau 2" labelSmall #065F46
              Spacer
              TextButton "Voir" labelMedium 12sp 600 #2563EB
              
  [Message photo/vidéo]
    Container w:200dp h:150dp radiusMd clipBehavior:antiAlias
      Stack:
        CachedNetworkImage fit:cover
        Positioned topRight: Container padding:4dp×6dp bg:#00000080 radiusFull
          "2:30" labelSmall 10sp #FFFFFF si vidéo
        Positioned bottomLeft: Container padding:6dp bg:gradient
          "Exercice du jour 💪" bodyMedium 14sp #FFFFFF

[Input zone] bg:#FFFFFF border-top:#F1F5F9 padding:8dp×16dp + safe area
  Row:
    IconButton Icons.add_circle_outline 24dp #64748B → bottomsheet attachments
      Options: "Photo/Vidéo", "Programme", "Exercice", "Document"
    SizedBox w:8dp
    Expanded Container minH:40dp maxH:120dp padding:10dp×16dp bg:#F1F5F9 radiusXl:
      TextField maxLines:5 minLines:1
        decoration: InputDecoration.collapsed hintText:"Tapez votre message..." #94A3B8
        style: bodyMedium 14sp #0F172A
    SizedBox w:8dp
    AnimatedSwitcher 200ms:
      Empty: IconButton Icons.mic 24dp #64748B → voice message
      HasText: Container 36×36dp bg:#2563EB circle:
        IconButton Icons.send 18dp #FFFFFF onPressed:sendMessage
```

### États spéciaux
- **Typing indicator** : "Marie est en train d'écrire..." avec 3 dots animés
- **Message non livré** : Icons.error 12dp #EF4444 + retry on tap
- **Partage d'exercice** : preview avec GIF + boutons "Essayer" / "Ajouter au programme"
- **Notification sounds** : son discret pour messages reçus

---

## 4. Client Dashboard (Vue Client)

### Context
Dashboard simplifié côté client pour consultation et réservation.

### Layout
```
[Custom Header] bg:gradient(#2563EB→#1D4ED8) padding:20dp h + safe area
  Row:
    Column flex:1:
      "Bonjour Marie 👋" headlineMedium 24sp Bold #FFFFFF
      SizedBox h:4dp  
      "Prêt pour votre séance ?" bodyMedium 14sp #FFFFFF70
    CircleAvatar r:28dp border:3dp #FFFFFF (photo client)

[Body scroll] bg:#F8FAFC padding:16dp h

[Card prochaine séance] bg:#FFFFFF radiusMd border:#F1F5F9 padding:20dp
  "Prochaine séance" titleMedium 16sp SemiBold #0F172A
  SizedBox h:12dp
  
  Row:
    Container 48×48dp bg:#DBEAFE radiusMd
      Icons.fitness_center 24dp #2563EB
    SizedBox w:12dp
    Expanded Column start:
      "Haut du corps" titleMedium 16sp SemiBold #0F172A
      "Demain • 14:00 - 15:00" bodyMedium 14sp #64748B
      "Avec Sarah Martin" bodySmall 12sp #64748B
    Column end:
      TextButton "Annuler" labelMedium 12sp #EF4444
      FilledButton "Détails" height:32dp bg:#2563EB labelMedium #FFFFFF

[SizedBox h:16dp]

[Row 2 actions rapides] gap:12dp
  ActionCard flex:1 bg:#FFFFFF padding:16dp center radiusMd:
    Icons.calendar_month 32dp #2563EB
    SizedBox h:8dp
    "Réserver" titleMedium 16sp SemiBold #0F172A
    "une séance" bodySmall 12sp #64748B
    
  ActionCard flex:1:
    Icons.chat_bubble_outline 32dp #10B981  
    "Contacter" / "mon coach"

[SizedBox h:16dp]

[Mes programmes] 
  Row: "Mes programmes" titleMedium 16sp SemiBold + "Voir tout" TextButton
  SizedBox h:12dp
  
  ProgramCard horizontal scroll w:280dp margin-r:12dp:
    bg:#FFFFFF radiusMd border:#F1F5F9 padding:16dp
      Row:
        Container 40×40dp bg:#D1FAE5 radiusSm Icons.trending_up 20dp #10B981
        SizedBox w:12dp
        Column start flex:1:
          "Programme Force" titleMedium 16sp SemiBold #0F172A
          "Semaine 3 sur 8" bodySmall 12sp #64748B
          SizedBox h:8dp
          LinearProgressIndicator value:0.375 bg:#F1F5F9 color:#10B981 h:4dp radiusFull
        Icons.chevron_right 18dp #CBD5E1

[SizedBox h:16dp]

[Historique récent]
  "Dernières séances" titleMedium 16sp SemiBold #0F172A
  SizedBox h:12dp
  
  3× SessionTile:
    Container mb:8dp padding:12dp×16dp bg:#FFFFFF radiusSm border:#F1F5F9
      Row:
        Container 8×8dp bg:#10B981 radiusFull (vert=fait, rouge=annulé, orange=reporté)
        SizedBox w:12dp
        Column start flex:1:
          "Haut du corps" bodyMedium 14sp 500 #0F172A  
          "Lundi 29 février • 14:00" bodySmall 12sp #64748B
        TextButton "Refaire" labelMedium 12sp 600 #2563EB
```

### Quick actions disponibles
- **Réservation** express : 1-tap pour créneaux favoris
- **SOS Coach** : message d'urgence (blessure, question nutrition)
- **Partage de progression** : photo/mesures avec coach
- **Rappels** : notifications personnalisées

---

## 5. Notifications Management

### Layout
```
[AppBar] "Notifications" headlineMedium + IconButton clear_all

[Body] ListView padding:16dp h

[FilterTabs] TabBar bg:#F1F5F9 radiusMd margin:16dp b
  "Toutes" "Messages" "Séances" "Programmes" "Système"
  selected: bg:#FFFFFF shadow:soft

[NotificationsList] groupBy:date
  SectionHeader "Aujourd'hui" labelMedium 12sp 600 #64748B padding:16dp t

  NotificationTile:
    Container padding:16dp×12dp bg:#FFFFFF margin:8dp b radiusSm border:#F1F5F9
      Row:
        Container 40×40dp bg:#DBEAFE radiusSm
          Icons.message 20dp #2563EB
        SizedBox w:12dp
        Expanded Column start:
          Row:
            "Nouveau message" bodyMedium 14sp 600 #0F172A flex:1
            "14:23" bodySmall 12sp #64748B
          SizedBox h:2dp
          "Marie: Merci pour la séance d'hier !" bodySmall 12sp #64748B maxLines:2
        Container 8×8dp bg:#2563EB radiusFull // unread dot
      
  NotificationTile priority:high bg:#FEF3C7:
    bg:#F59E0B icon + "Séance dans 1h" + "N'oubliez pas votre séance avec Paul à 15h"
    
  NotificationTile read: opacity:0.6, no dot
```

### Types de notifications
- **Messages** : nouveaux messages, mentions
- **Séances** : rappels 1h/24h avant, confirmations, annulations
- **Programmes** : nouveau programme assigné, objectifs atteints
- **Système** : mises à jour app, maintenance, nouvelles fonctionnalités

---

## Intégration & Coordination avec dev

### API requirements (pour dev-python)
```typescript
// Client creation
POST /clients/create {name, email, phone, fitness_level, goals, preferences}
GET /clients/{id}/profile

// Dashboard data  
GET /coaches/{id}/dashboard/stats
GET /coaches/{id}/dashboard/tasks
GET /coaches/{id}/planning/week?date=YYYY-MM-DD

// Chat
GET /conversations/{id}/messages?limit=50&offset=0
POST /conversations/{id}/messages {content, type, attachments}
PUT /messages/{id}/read

// Notifications
GET /notifications?filter=all|messages|sessions|system&limit=20
PUT /notifications/{id}/read
DELETE /notifications/{id}
```

### Flutter state management (pour dev-flutter)
- **BlocProvider** pour chaque screen avec états loading/loaded/error
- **SharedPreferences** pour settings notifications
- **Local Database** (Drift/Floor) pour cache messages offline
- **FCM** pour push notifications
- **Image picker/camera** pour partage photos exercices

### Design tokens synchronisation
Tous ces écrans utilisent strictement le design system défini dans les 12 maquettes existantes :
- Couleurs : #2563EB primary, #10B981 secondary  
- Typography : Inter avec scales Material 3
- Spacings : multiples de 4dp (xs=4, sm=8, md=12, base=16, etc.)
- Rayons : radiusSm=8, radiusMd=12, radiusLg=16, radiusXl=24

### Performance optimizations
- **ListView.builder** obligatoire pour listes >10 items
- **CachedNetworkImage** pour photos profils et exercices  
- **Shimmer placeholders** pendant chargements
- **Debouncing** sur search et form inputs (300ms)
- **Pagination** sur historiques et listes longues (20 items/page)

Ces écrans avancés complètent parfaitement l'écosystème MyCoach en restant cohérents avec l'expérience utilisateur établie.