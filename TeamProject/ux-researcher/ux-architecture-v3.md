# UX Architecture V3 — MyCoach
*Sitemap complet des 60+ écrans*

## Vue d'ensemble

**Total :** ~60 écrans répartis sur 2 espaces utilisateurs distincts
- **Espace Client** : 35 écrans (interface claire/dynamique)
- **Espace Coach** : 25 écrans (interface sombre/tech)

---

## 🔧 Onboarding & Authentification
*Commun aux deux espaces*

```
├── 01_Splash_Screen
├── 02_Onboarding_Welcome
├── 03_Login
├── 04_Register
├── 05_Profile_Type_Selection (Coach/Client)
└── 06_Profile_Setup
    ├── Client_Profile
    │   ├── 06a_Personal_Info
    │   ├── 06b_Fitness_Goals
    │   ├── 06c_Gym_Selection
    │   └── 06d_Questionnaire_Form
    └── Coach_Profile
        ├── 06e_Professional_Info
        ├── 06f_Certifications
        └── 06g_Banking_Details
```

## 👤 Espace Client (35 écrans)

### Dashboard & Navigation Principal
```
Client/
├── 01_Dashboard_Client
├── 02_Bottom_Navigation
├── 03_Profile_Settings
├── 04_Notifications_Center
└── 05_Search_Global
```

### Planning & Réservations
```
Client/Planning/
├── 06_Calendar_View
├── 07_Coach_Search
├── 08_Coach_Profile_Public
├── 09_Booking_Session
├── 10_Discovery_Tunnel
├── 11_Payment_Method
├── 12_Booking_Confirmation
└── 13_Session_Details
```

### Performances & Tracking
```
Client/Performance/
├── 14_Performance_Dashboard
├── 15_Add_Performance
│   ├── 15a_Running_Input
│   ├── 15b_Machine_Input
│   ├── 15c_Free_Weight_Input
│   └── 15d_Other_Activity_Input
├── 16_Performance_History
├── 17_Performance_Detail
├── 18_Connected_Devices
└── 19_Progress_Charts
```

### Programmes & Entraînement
```
Client/Programs/
├── 20_Program_Catalog
├── 21_Program_Detail
├── 22_My_Programs
├── 23_Program_Generation_AI
├── 24_Guided_Workout_Mode
│   ├── 24a_Exercise_Screen
│   ├── 24b_Rest_Timer
│   └── 24c_Set_Counter
├── 25_Workout_Summary
└── 26_Exercise_Library
```

### Communication & Social
```
Client/Communication/
├── 27_Messages_List
├── 28_Chat_Coach
├── 29_Video_Call_Interface
├── 30_Group_Messages
└── 31_Feedback_Rating
```

### Gamification & Récompenses
```
Client/Gamification/
├── 32_Achievements_Board
├── 33_Leaderboard
├── 34_Challenges_Active
└── 35_Rewards_Center
```

## 👨‍💼 Espace Coach (25 écrans)

### Dashboard & Analytics
```
Coach/
├── 01_Dashboard_Coach
├── 02_Analytics_Revenue
├── 03_Analytics_Client_Progress
├── 04_Calendar_Management
└── 05_Notifications_Coach
```

### Gestion Clients
```
Coach/Clients/
├── 06_Client_List
├── 07_Client_Profile_Detail
├── 08_Client_Notes_Private
├── 09_Credit_Hours_Management
├── 10_Client_Progress_Tracking
└── 11_Client_Communication_Hub
```

### Programmes & Contenu
```
Coach/Programs/
├── 12_Program_Library
├── 13_Program_Creation
├── 14_Program_Editor
├── 15_Program_Assignment
├── 16_Exercise_Database
└── 17_Video_Content_Manager
```

### Business & Revenus
```
Coach/Business/
├── 18_Pricing_Management
├── 19_Package_Creation
├── 20_Payment_Options
├── 21_Revenue_Dashboard
├── 22_Invoice_Generation
├── 23_Tax_Reports
└── 24_Professional_Profile_Settings
```

### Outils Coaching
```
Coach/Tools/
└── 25_Session_Live_Tools
    ├── 25a_Timer_Multiple
    ├── 25b_Form_Analysis
    └── 25c_Real_Time_Metrics
```

---

## 🔄 Écrans Transversaux

### Modales & Composants Réutilisables
```
Shared/
├── Loading_States (3 variations)
├── Error_States (4 variations) 
├── Empty_States (5 variations)
├── Image_Picker_Modal
├── Date_Time_Picker
├── Payment_Modal
├── Confirmation_Dialogs (3 types)
├── Filter_Bottom_Sheet
└── Settings_Menu
```

### Notifications Push
```
Notifications/
├── Session_Reminder
├── Performance_Achievement
├── Message_Received
├── Payment_Due
└── Program_Update
```

---

## 📱 Architecture Responsive

### Breakpoints
- **Mobile Portrait** : 320-414px (priorité)
- **Mobile Landscape** : 568-896px 
- **Tablet Portrait** : 768-834px
- **Tablet Landscape** : 1024-1194px

### Components Adaptatifs
- Navigation : Bottom tabs (mobile) / Side nav (tablet)
- Calendrier : Semaine (mobile) / Mois (tablet)
- Listes : 1 colonne (mobile) / 2 colonnes (tablet)

---

## 🎨 Design System Integration

### Coach Space (Dark Theme)
- Background : `#0A0E1A` → `#1A1F2E` (gradients)
- Primary : `#7B2FFF` (violet électrique)
- Accent : `#FF6B2F` (orange énergie)
- Text : `#FFFFFF` → `#B8C4D6`

### Client Space (Light Theme)  
- Background : `#F0F4FF` → `#FFFFFF` (gradients)
- Primary : `#00C2FF` (cyan dynamique)
- Accent : `#FF6B2F` (orange énergie)
- Text : `#1A1F2E` → `#666B78`

### Typography Scale
- H1 : 32px / Bold (Page titles)
- H2 : 24px / SemiBold (Section headers)
- H3 : 20px / Medium (Card titles)
- Body : 16px / Regular (Main content)
- Caption : 12px / Regular (Meta info)

---

## 🌐 Internationalisation

### Écrans Impactés par i18n
- Tous les formulaires (8 langues)
- Sélection gym (données locales par pays)
- Devises et unités de mesure
- Formats de date/heure
- Numéros de téléphone (formats nationaux)

### Contenus Dynamiques
- Exercices traduits (base données multilingue)
- Notifications push localisées
- Emails transactionnels
- CGU/Privacy par juridiction

---

## 📊 Métriques UX Cibles

### Temps de Navigation
- Onboarding complet : < 5 min
- Réservation session : < 3 min  
- Ajout performance : < 1 min
- Navigation entre écrans : < 0.3s

### Taux de Conversion
- Inscription → Profil complet : > 80%
- Visiteur → Première réservation : > 15%
- Session réservée → Session effectuée : > 90%

### Accessibilité (WCAG 2.1 AA)
- Contraste : ≥ 4.5:1 (texte normal)
- Touch targets : ≥ 44px
- Navigation clavier complète
- Screen reader compatible