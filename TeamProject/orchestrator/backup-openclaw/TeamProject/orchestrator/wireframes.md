# MyCoach — Wireframes Flutter (8 écrans)

---

## 1. Login / Register

```
┌─────────────────────────────┐
│         🏋️ MyCoach          │
│                             │
│  ┌─────────────────────┐    │
│  │ Email               │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Mot de passe    👁   │    │
│  └─────────────────────┘    │
│                             │
│  [    Se connecter     ]    │  ← bouton primary
│                             │
│  Mot de passe oublié ?      │  ← lien texte
│                             │
│  ─── ou ───                 │
│                             │
│  Pas encore de compte ?     │
│  [  Créer un compte   ]    │  ← bouton secondary
│                             │
│  ── Écran Register ──       │
│  ┌─────────────────────┐    │
│  │ Prénom              │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Nom                 │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Email               │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Mot de passe    👁   │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Confirmer mdp   👁   │    │
│  └─────────────────────┘    │
│                             │
│  [    S'inscrire       ]    │
└─────────────────────────────┘
```

---

## 2. Dashboard Coach

```
┌─────────────────────────────┐
│ ☰  Dashboard        🔔 (3) │
├─────────────────────────────┤
│ Bonjour, Marc 👋            │
│                             │
│ ┌───────┐ ┌───────┐        │
│ │  12   │ │   8   │        │
│ │clients│ │actifs │        │
│ └───────┘ └───────┘        │
│ ┌───────┐ ┌───────┐        │
│ │   5   │ │  23   │        │
│ │progr. │ │séances│        │
│ └───────┘ └───────┘ /mois  │
│                             │
│ ⚠️ 12/15 clients (Free)     │
│ [ Passer Pro ]              │
│                             │
│ ── Prochaines séances ──    │
│ 📅 Lun 3 mars  09:00       │
│    Sophie D. — Full Body    │
│ 📅 Lun 3 mars  11:00       │
│    Julien M. — Cardio       │
│                             │
│ ── Activité récente ──      │
│ ✅ Sophie a terminé Jour 12 │
│ 📩 Nouveau msg de Julien    │
│ 📊 Paul a logué 78kg        │
│                             │
├────┬────┬────┬────┬────────┤
│ 🏠 │ 👥 │ 📋 │ 💬 │  👤   │
│Home│Cli.│Prog│Chat│Profil  │
└────┴────┴────┴────┴────────┘
```

---

## 3. Liste Clients

```
┌─────────────────────────────┐
│ ←  Mes Clients    [+ Inviter]│
├─────────────────────────────┤
│ 🔍 Rechercher...            │
│                             │
│ [Tous] [Actifs] [Invités]   │  ← filtres chips
│                             │
│ ┌─────────────────────────┐ │
│ │ 🟢 Sophie Dupont        │ │
│ │    Dernier log: hier    │ │
│ │    Programme: Full Body │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 🟢 Julien Martin        │ │
│ │    Dernier log: 2j      │ │
│ │    Programme: Cardio    │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 🟡 Paul Renard          │ │
│ │    Invitation envoyée   │ │
│ │    —                    │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ ⚫ Marie Leroy (archivé)│ │
│ └─────────────────────────┘ │
│                             │
│         12/15 clients       │
├────┬────┬────┬────┬────────┤
│ 🏠 │ 👥 │ 📋 │ 💬 │  👤   │
└────┴────┴────┴────┴────────┘
```

---

## 4. Fiche Client

```
┌─────────────────────────────┐
│ ←  Sophie Dupont    [💬][⋮] │
├─────────────────────────────┤
│       (avatar)              │
│    sophie@email.com         │
│    06 12 34 56 78           │
│    Inscrite le 15/01/2026   │
│    Statut: 🟢 Active        │
│                             │
│ ── Programmes ──            │
│ ┌─────────────────────────┐ │
│ │ 📋 Full Body 12 sem.    │ │
│ │    Progression: ████░ 75%│ │
│ │    Depuis: 15/01/2026   │ │
│ └─────────────────────────┘ │
│ [ + Assigner programme ]    │
│                             │
│ ── Métriques ──             │
│ Poids: 65kg → 62kg 📉      │
│ Tour taille: 78cm → 74cm   │
│ [ + Ajouter métrique ]      │
│                             │
│ ── Dernières séances ──     │
│ ✅ Jour 9 — 28/02 ⭐⭐⭐⭐   │
│ ✅ Jour 8 — 26/02 ⭐⭐⭐⭐⭐  │
│ ⏭ Jour 7 — 24/02 (skipped) │
│                             │
│ ── Notes ──                 │
│ ┌─────────────────────────┐ │
│ │ Objectif: marathon mai  │ │
│ │ Genou droit sensible    │ │
│ └─────────────────────────┘ │
│                             │
│ [🗑 Archiver ce client]     │
└─────────────────────────────┘
```

---

## 5. Création Programme

```
┌─────────────────────────────┐
│ ←  Nouveau Programme  [Save]│
├─────────────────────────────┤
│  ┌─────────────────────┐    │
│  │ Titre du programme  │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Description          │    │
│  │                     │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Objectif            │    │
│  └─────────────────────┘    │
│                             │
│  Durée: [ 8 ] semaines     │
│  Niveau: [Débutant ▼]      │
│  ☐ Sauver comme template   │
│                             │
│ ── Séances ──               │
│ ┌─────────────────────────┐ │
│ │ Sem 1 / Jour 1          │ │
│ │ "Upper Body Push"       │ │
│ │ 45 min — 6 exercices    │ │
│ │              [✏️] [🗑]   │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ Sem 1 / Jour 2          │ │
│ │ "Lower Body"            │ │
│ │ 50 min — 5 exercices    │ │
│ │              [✏️] [🗑]   │ │
│ └─────────────────────────┘ │
│                             │
│ [ + Ajouter une séance ]    │
│                             │
│ ── Détail séance (expand) ──│
│ Séance: Upper Body Push     │
│ ┌──────────────────────┐    │
│ │ 1. Bench Press       │    │
│ │    4x10 — 60kg       │    │
│ │    Repos: 90s        │    │
│ │            [✏️] [🗑]  │    │
│ ├──────────────────────┤    │
│ │ 2. OHP               │    │
│ │    3x12 — 30kg       │    │
│ │    Repos: 60s        │    │
│ │            [✏️] [🗑]  │    │
│ └──────────────────────┘    │
│ [ + Ajouter exercice ]      │
│                             │
│ [  Dupliquer programme  ]   │
└─────────────────────────────┘
```

---

## 6. Vue Programme (côté Client)

```
┌─────────────────────────────┐
│ ←  Full Body 12 sem.       │
├─────────────────────────────┤
│ Coach: Marc Petit           │
│ Objectif: Remise en forme   │
│ Progression: ████████░ 75%  │
│                             │
│ ── Semaine 9 (en cours) ──  │
│                             │
│ ┌─────────────────────────┐ │
│ │ ✅ Jour 1 — Upper Body  │ │
│ │    Fait le 27/02 ⭐⭐⭐⭐  │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 🔵 Jour 2 — Lower Body │ │  ← à faire
│ │    6 exercices — 50 min │ │
│ │    [ Commencer ]        │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ ⚪ Jour 3 — Cardio      │ │  ← verrouillé
│ │    5 exercices — 40 min │ │
│ └─────────────────────────┘ │
│                             │
│ ── Détail séance active ──  │
│ Lower Body                  │
│ 1. □ Squat     4x12 60kg   │
│ 2. □ Leg Press 3x15 80kg   │
│ 3. □ Fentes    3x12 BW     │
│ 4. □ Leg Curl  3x12 30kg   │
│ 5. □ Mollets   4x15 40kg   │
│ 6. □ Planche   3x45s       │
│                             │
│ [ Logger cette séance ]     │
│                             │
│ ── Log popup ──             │
│ Comment ça s'est passé ?    │
│ ⭐⭐⭐⭐☆                    │
│ Notes: [               ]    │
│ [ Valider ]                 │
└─────────────────────────────┘
```

---

## 7. Chat (Messagerie)

```
┌─────────────────────────────┐
│ ←  Messages                 │
├─────────────────────────────┤
│                             │
│ ┌─────────────────────────┐ │  ← liste conversations
│ │ 🔵 Sophie Dupont        │ │
│ │   "Merci coach ! À d…" │ │
│ │              il y a 2h  │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │    Julien Martin        │ │
│ │   "Ok pour lundi 9h"   │ │
│ │              hier       │ │
│ └─────────────────────────┘ │
│                             │
│ ══ Conversation ouverte ══  │
│                             │
│ ┌─────────────────────────┐ │
│ │ ← Sophie Dupont     📞  │ │
│ ├─────────────────────────┤ │
│ │                         │ │
│ │  ┌──────────────┐       │ │
│ │  │ Salut Sophie,│       │ │
│ │  │ comment va le│  14:02│ │
│ │  │ genou ?      │       │ │
│ │  └──────────────┘       │ │
│ │                         │ │
│ │       ┌──────────────┐  │ │
│ │       │Beaucoup mieux│  │ │
│ │ 14:05 │j'ai pu faire │  │ │
│ │       │la séance !   │  │ │
│ │       └──────────────┘  │ │
│ │                         │ │
│ │  ┌──────────────┐       │ │
│ │  │ Super ! On    │       │ │
│ │  │ augmente les │ 14:06 │ │
│ │  │ charges sem  │       │ │
│ │  │ prochaine    │       │ │
│ │  └──────────────┘       │ │
│ │                         │ │
│ │       ┌──────────────┐  │ │
│ │       │Merci coach ! │  │ │
│ │ 14:08 │À demain 💪   │  │ │
│ │       └──────────────┘  │ │
│ │                         │ │
│ ├─────────────────────────┤ │
│ │ [Message...        ] 📎➤│ │
│ └─────────────────────────┘ │
│                             │
├────┬────┬────┬────┬────────┤
│ 🏠 │ 👥 │ 📋 │ 💬 │  👤   │
└────┴────┴────┴────┴────────┘
```

---

## 8. Profil Coach

```
┌─────────────────────────────┐
│ ←  Mon Profil        [Save] │
├─────────────────────────────┤
│                             │
│        (avatar)             │
│     [ Changer photo ]       │
│                             │
│  ┌─────────────────────┐    │
│  │ Prénom: Marc        │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Nom: Petit          │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Email: marc@coach.fr│    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Tél: 06 98 76 54 32│    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ Bio:                │    │
│  │ Coach sportif certif│    │
│  │ ié, spécialisé en   │    │
│  │ remise en forme...  │    │
│  └─────────────────────┘    │
│                             │
│  Spécialités:               │
│  [Musculation] [Cardio]     │
│  [Remise en forme]          │
│  [ + Ajouter ]              │
│                             │
│ ── Plan ──                  │
│ 📋 Free — 12/15 clients     │
│ [ Passer à Pro — 29€/mois ] │
│                             │
│ ── Compte ──                │
│ [ Changer mot de passe ]    │
│ [ Se déconnecter ]          │
│                             │
├────┬────┬────┬────┬────────┤
│ 🏠 │ 👥 │ 📋 │ 💬 │  👤   │
└────┴────┴────┴────┴────────┘
```

---

## Résumé de la navigation (Bottom Tab Bar)

| Icône | Onglet | Écran principal |
|-------|--------|-----------------|
| 🏠 | Home | Dashboard Coach |
| 👥 | Clients | Liste Clients → Fiche Client |
| 📋 | Programmes | Liste Programmes → Création/Édition |
| 💬 | Chat | Liste Conversations → Conversation |
| 👤 | Profil | Profil Coach |
