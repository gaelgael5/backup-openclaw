# Notes de Coordination MVP MyCoach

## 📅 Session Product Manager — 02 Mars 2026 21:18

**Mission :** Coordination équipe dev MVP MyCoach  
**Équipes actives :** dev-python, dev-flutter  
**Status :** 🔄 COORDINATION ACTIVE

---

## 🎯 État actuel du projet

### ✅ Ce qui est fait
- **Backlog MVP** : 9 user stories P0 priorisées et estimées
- **API Contract** : OpenAPI spec détaillé disponible (`api-contract.yaml`)
- **Architecture** : Stack Flutter + FastAPI + PostgreSQL définie
- **Décisions produit** : Scope MVP clarifié (auth simple, paiements manuels)

### 🚧 En cours d'analyse
- **Points bloquants** : 6 questions critiques identifiées pour dev teams
- **Coordination API** : Contrats Flutter ↔ Backend à valider
- **Milestones planning** : 6 jalons définis avec critères acceptation

### ⚠️ Blockers identifiés
1. **CRITIQUE** : Architecture créneaux disponibilités (backend vs flutter)
2. **CRITIQUE** : Flow onboarding exact après inscription
3. **IMPORTANT** : Stratégie upload fichiers (local vs cloud)

---

## 📋 Livrables Product Manager créés

### 1. `api-specs.md` — Spécifications API détaillées
**Contenu :**
- Contrats API Flutter ↔ Python pour MVP (P0 endpoints)
- Format requests/responses avec exemples YAML
- Points bloquants dev identifiés (6 critiques + importantes)
- Actions techniques assignées par équipe
- Coordination sync dev requise dans 24h

**Status :** ✅ LIVRÉ — À valider par dev-python + dev-flutter

### 2. `mvp-milestones.md` — Jalons et critères d'acceptation
**Contenu :**
- 6 milestones MVP avec durées estimées (5-6 semaines total)
- Critères d'acceptation détaillés backend + frontend par milestone
- Demo objectives pour chaque jalon
- Success metrics business + technique
- Points de blocage critiques avec deadlines décision

**Status :** ✅ LIVRÉ — Ready for milestone planning

### 3. `coordination-notes.md` — Notes coordination équipe
**Contenu :**
- Ce fichier actuel avec status projet + next steps
- Agenda sync dev teams + points validation
- Risk management + mitigation strategies
- Communication protocols avec équipes

**Status :** ✅ LIVRÉ — Guide coordination active

---

## 🚨 Actions urgentes équipe dev

### 🔴 IMMÉDIAT (24h)
1. **dev-python + dev-flutter** : Review `api-specs.md` 
   - Valider endpoints structure proposée
   - Clarifier points bloquants identifiés (créneaux, onboarding, upload)
   - Confirmer faisabilité techniques + estimations

2. **dev-python** : Architecture decisions
   - Gestion créneaux disponibilités : logic backend ou flutter ?
   - File upload strategy : local storage ou cloud ?
   - Error handling : format standardisé codes + messages ?

3. **dev-flutter** : UX flow decisions  
   - Onboarding sequence : mandatory profile completion ?
   - Navigation post-signup : auto-redirect ou choice ?
   - State management : Provider/Riverpod final choice ?

### 🟡 CETTE SEMAINE (7j)
1. **Milestone 1 kickoff** : Foundation Auth
   - dev-python : Setup project + auth endpoints + JWT
   - dev-flutter : Auth screens + navigation + http client
   - Target : Demo fonctionnel signup → login → role-based routing

2. **Technical foundation**
   - Database schema finalized + migrations
   - CI/CD pipeline basic setup
   - Development environments synchronized

---

## 🔄 Coordination protocols

### Daily standups (recommandé)
- **Format :** Async update dans canaux Discord teams
- **Timing :** Matin (09:00) pour sync journalière
- **Content :** Yesterday done / Today plan / Blockers identified

### Weekly milestone reviews
- **Format :** Demo session + retrospective
- **Timing :** Vendredi 16:00 (fin semaine)  
- **Content :** Milestone achievement / Next planning / Risks mitigation

### Escalation process
- **Blockers techniques** → Product Manager (moi) dans 24h max
- **Questions business** → Product Manager immédiat
- **Architecture decisions** → Dev teams sync + PM validation
- **Scope changes** → PM + stakeholder validation required

---

## 📊 Risk Management

### 🔴 HIGH RISKS

1. **Créneaux disponibilités complexity**
   - **Risk :** Architecture mal définie → dev teams blocked
   - **Mitigation :** Sync dev teams immédiat + decision dans 48h
   - **Fallback :** Simple time slots sans récurrence MVP

2. **API contract misalignment**
   - **Risk :** Backend/Frontend incompatible implementations
   - **Mitigation :** Review `api-specs.md` par les 2 teams avant dev
   - **Fallback :** Mock API backend + progressive integration

3. **Scope creep**
   - **Risk :** Features P1/P2 leaked dans MVP
   - **Mitigation :** Product Manager gate keeper strict
   - **Fallback :** Reprioritization + timeline adjustment

### 🟡 MEDIUM RISKS

4. **Performance mobile**
   - **Risk :** App lag sur devices moyens
   - **Mitigation :** Performance testing dès Milestone 3
   - **Fallback :** Optimizations pass before MVP delivery

5. **File upload complexity**
   - **Risk :** Photo/certif upload unreliable
   - **Mitigation :** Decision local vs cloud dans 48h
   - **Fallback :** Simple local storage MVP + cloud post-MVP

---

## 💬 Communication avec équipes

### Messages types pour dev teams

#### 🔴 Blockers escalation
```
[URGENT] Blocker technique détecté
- Component/Feature: [X]
- Issue: [Description claire]
- Impact: [Milestone affecté]
- Need: [Décision/ressource required]
- Deadline: [Timeline critique]
```

#### ✅ Milestone completion
```
[MILESTONE DONE] Milestone X completed
- Features delivered: [Liste]
- Demo available: [URL/instructions]
- Next milestone: [Planning]
- Blockers for next: [Issues identified]
```

#### ⚠️ Scope clarification request
```
[CLARIFICATION] Feature requirement unclear
- User story: [US-XXX]
- Unclear aspect: [Détail specific]
- Options considered: [A, B, C]
- Recommandation: [PM input needed]
```

---

## 📈 Success indicators

### 💚 ON TRACK signals
- ✅ Daily updates from dev teams
- ✅ Milestones demo-able on schedule
- ✅ API specs questions resolved < 24h
- ✅ Blockers escalated early + resolved quickly

### 🟡 AT RISK signals  
- ⚠️ Silence from dev team > 24h
- ⚠️ Milestone delivery slipping without replan
- ⚠️ Blockers non-escalated + festering
- ⚠️ Scope creep discussions emerging

### 🔴 CRISIS signals
- ❌ Multiple milestones compromised
- ❌ Architecture fundamental changes required
- ❌ Team conflicts blocking progress
- ❌ Technical unfeasibility discovered late

---

## 📅 Next coordination checkpoints

### 🎯 J+1 (03 Mars)
- [ ] Reception feedback `api-specs.md` des dev teams
- [ ] Resolution points bloquants architecture (créneaux + upload)
- [ ] Validation faisabilité Milestone 1 timeline

### 🎯 J+3 (05 Mars)  
- [ ] Kickoff Milestone 1 avec demo targets clairs
- [ ] Setup coordination protocols (daily + weekly sync)
- [ ] Risk mitigation strategies activated

### 🎯 J+7 (09 Mars)
- [ ] Premier weekly milestone review
- [ ] Validation progression foundation auth
- [ ] Planning Milestone 2 coach onboarding

---

## 📝 Notes internes PM

### Lessons learned so far
- **API contract early** crucial pour éviter rework
- **Blockers identification proactive** vs reactive debugging
- **Milestones crisp boundaries** meilleur que features floues

### À surveiller attentivement
- **Dev teams communication frequency** — silence = risk
- **Technical debt accumulation** — quality vs speed balance
- **Scope discipline** — business pressure vs MVP focus

### Décisions en attente
- [ ] **Créneaux architecture** : Backend algorithm vs Flutter local
- [ ] **Upload strategy** : Local files vs cloud S3-compatible  
- [ ] **Error handling** : Format standardisé API errors
- [ ] **Testing strategy** : Unit vs integration vs E2E balance

---

**🚀 Status :** Coordination active jusqu'à MVP ready  
**📞 Contact :** Product Manager via #product-backlog pour escalations