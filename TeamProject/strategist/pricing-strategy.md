# Stratégie de Pricing MyCoach — 2 Mars 2026

## Synthèse exécutive

- **Positionnement premium-accessible** : €25-35/mois pour coachs indépendants (vs €18-45 concurrence)
- **Freemium limité** : 3 clients max gratuit (vs 1-2 concurrents) pour essai réel
- **Pricing transparent EUR** : Avantage concurrentiel face prix USD cachés
- **Value-based pricing** : Facturation ROI coach (€300 économie admin/mois) vs feature-based
- **Modèle hybride** : SaaS récurrent + commission optionnelle paiements (2.5% vs 2.9% Stripe)

## Benchmarking concurrentiel pricing

### Analyse prix marché

| Concurrent | Prix entrée | Prix standard | Prix premium | Modèle |
|------------|-------------|---------------|--------------|--------|
| **Trainerize** | $0 (1 client) | $19.80 (200 clients) | $225 (Studio) | Freemium + Tiers |
| **TrueCoach** | Essai 14j | ~$50-150/mois (estimé) | Custom | Trial + Custom |
| **Calendly+Stripe** | €0 + 1.4% | €10 + 1.4% | €15 + 1.4% | Freemium + Commission |
| **MyFitnessPal** | €6.67/mois | €8.34/mois | - | B2C Subscription |

### Insights pricing
- **Gap €20-50** : Trainerize saute de $9 à $19.80, TrueCoach prix cachés/élevés
- **Freemium débalancé** : 1 client = pas d'usage réel, 200 clients = over-serving
- **Commission vs SaaS** : Modèles mixtes (Stripe integré) vs pure SaaS
- **Pricing opaque** : TrueCoach cache prix = friction acquisition

## Stratégie pricing MyCoach

### Modèle freemium + tiered SaaS

#### **Plan Découverte (Gratuit)**
- **Clients** : 3 maximum (vs 1-2 concurrents)
- **Durée** : Illimitée (vs 14j trials)
- **Features** : Profil coach, booking basique, 1 type de séance
- **Objectif** : Trial réel usage 2-3 clients pour validation value
- **Conversion** : 25-30% vers payant (benchmark 20% SaaS B2B)

#### **Plan Coach (€29/mois)**
- **Clients** : 25 maximum
- **Features** : Profils clients complets, types séances illimités, paiements manuels, calendrier sync
- **Target** : Coachs indépendants établis 5-25 clients
- **Positioning** : Sweet spot vs gap concurrentiel €9-€19.80
- **ROI** : €300+ économie admin/mois vs gestion manuelle

#### **Plan Expert (€49/mois)**
- **Clients** : 100 maximum  
- **Features** : Paiements en ligne (Stripe), forfaits/packages, analytics, export comptable
- **Target** : Coachs expérimentés 25-100 clients
- **Positioning** : Premium accessible vs TrueCoach opaque
- **ROI** : €500+ économie/mois + revenus additionnels

#### **Plan Studio (€99/mois)**
- **Clients** : 300 maximum
- **Features** : Multi-coachs, branding personnalisé, API access, support prioritaire
- **Target** : Petits studios, coachs premium 100+ clients
- **Positioning** : Alternative française Trainerize Studio ($225)
- **ROI** : €1000+ économie vs solutions enterprise

### Commissions optionnelles

#### **MyCoach Payments (optionnel)**
- **Commission** : 2.5% par transaction (vs 2.9% Stripe direct)
- **Value-add** : Facturation automatique française, export comptable, réconciliation
- **Target** : Plans Coach+ qui veulent paiements intégrés
- **Revenue split** : Commission partagée avec Stripe (0.6% marge MyCoach)

### Pricing psychology et justification

#### **€29 Plan Coach (anchor price)**
- **Benchmark** : Trainerize $19.80 = ~€18.50, mais features limitées
- **Justification** : +€10.50 pour compliance française, UX native, support EUR
- **Psychology** : Prix rond français vs $19.80 complexe
- **Value** : Coach économise €300+/mois admin, payback <3 jours

#### **Progression naturelle**
- **Gratuit → €29** : 3 → 25 clients (8x capacité)
- **€29 → €49** : 25 → 100 clients (4x capacité) + paiements en ligne
- **€49 → €99** : 100 → 300 clients (3x capacité) + features studio

#### **Pricing transparent EUR**
- **Avantage** : Pas de conversion USD, TVA incluse, prix finale visible
- **Messaging** : "Prix français, pour coachs français"
- **Trust** : Pas de surprise billing, budgeting facilité

## Freemium vs Premium strategy

### Pourquoi freemium (pas trial)

#### **Avantages freemium permanent**
- **Usage réel** : 3 clients = workflow complet testable
- **Viral organic** : Clients voient interface MyCoach lors booking
- **Low-touch conversion** : Pas de re-onboarding après trial
- **Community building** : Base users gratuits = ambassadeurs

#### **Risques freemium managed**
- **Abuse prevention** : 1 compte gratuit par email/téléphone
- **Feature gating** : Pas d'export, analytics limitées, support communautaire
- **Conversion drivers** : Notifications limits clients, branding MyCoach

### Premium features justification

#### **Plan Coach (€29) key differentiators**
- **Profils clients avancés** : Historique, notes, objectifs (vs basique gratuit)
- **Calendrier sync** : Google/Outlook integration (vs manuel)
- **Types séances illimités** : Spécialisations multiples (vs 1 gratuit)
- **Export basique** : CSV clients/séances pour comptabilité

#### **Plan Expert (€49) premium value**
- **Paiements en ligne** : Stripe intégré, facturation automatique
- **Packages/forfaits** : Vente séries, abonnements, revenus récurrents
- **Analytics** : Dashboard revenus, clients actifs, conversion
- **Export comptable** : Format expert-comptable français

#### **Plan Studio (€99) enterprise features**
- **Multi-coaches** : Gestion équipe, assignations, revenus partagés
- **White-label** : Branding personnalisé, domaine custom
- **API access** : Intégrations tierces, workflow automation
- **Support prioritaire** : Phone/email dédié, onboarding personnalisé

## Optimisation conversion et retention

### Conversion funnel optimization

#### **Gratuit → Coach (€29)**
- **Trigger** : Limite 3 clients atteinte
- **Incentive** : -50% premier mois (€14.50) si upgrade immediate
- **Timeline** : Conversion moyenne J+30-45 (3 clients acquis)
- **Support** : Email onboarding sequence, success stories

#### **Coach → Expert (€49)**
- **Trigger** : 15+ clients actifs OU demande paiements en ligne
- **Incentive** : Essai Expert 1 mois gratuit
- **Value** : Calcul ROI paiements automatiques (+€200 revenus/mois estimé)
- **Timeline** : Upgrade M3-M6 post adoption

#### **Expert → Studio (€99)**
- **Trigger** : 50+ clients OU ajout 2ème coach
- **Incentive** : Migration données + branding setup inclus
- **Value** : Positioning transition solo → business
- **Timeline** : Upgrade M6-M12, croissance business

### Retention strategy

#### **Value realization tracking**
- **Onboarding** : Setup 3 premiers clients guidé (gratuit)
- **Success metrics** : Clients acquis, séances réalisées, revenus trackés
- **Regular check-ins** : Email mensuel ROI, comparaison période précédente

#### **Engagement drives retention**
- **Community** : Forum coaches, partage best practices
- **Content** : Webinars business, guides marketing coaching
- **Recognition** : Coach du mois, success stories clients

#### **Churn prevention**
- **Usage alerts** : Baisse activité = outreach proactif
- **Downgrade option** : Plan inférieur vs churn total
- **Win-back** : Offer 3 mois 50% si churn récent

## Revenue projections et sensitivité

### Modèle financier Y1-Y3

| Métrique | Y1 | Y2 | Y3 |
|----------|----|----|-----|
| **Users gratuits** | 800 | 1500 | 2200 |
| **Plan Coach (€29)** | 180 | 400 | 650 |
| **Plan Expert (€49)** | 45 | 150 | 300 |
| **Plan Studio (€99)** | 8 | 35 | 80 |
| **Revenue SaaS** | €95k | €285k | €510k |
| **Revenue Commissions** | €15k | €60k | €140k |
| **Revenue total** | €110k | €345k | €650k |

### Sensitivité pricing

#### **Scenario +€5 across plans** (€34/€54/€104)
- **Impact** : +€35k revenue Y1 (-15% conversion) = Net +€20k
- **Risk** : Competitive disadvantage vs Trainerize

#### **Scenario -€5 across plans** (€24/€44/€94)  
- **Impact** : +25% conversion, -€25k revenue Y1 = Net -€5k
- **Benefit** : Market share capture, faster scale

#### **Recommendation** : Maintenir €29/€49/€99 Y1, re-évaluation Y2 selon adoption

## Implementation roadmap

### Launch strategy (M1-M3)
- **MVP** : Plan Découverte + Plan Coach uniquement
- **Focus** : Product-market fit, conversion gratuit→payant
- **Pricing** : €29 fixe, pas d'annual discount

### Growth phase (M4-M12)
- **Rollout** : Plan Expert (M4), Plan Studio (M8)
- **Optimization** : A/B test conversion incentives, annual plans
- **Expansion** : Commission payments (M6)

### Scale phase (M13+)
- **Enterprise** : Plans custom >300 clients
- **International** : Pricing localisé Belgique/Suisse
- **Platform** : API marketplace, third-party integrations

## KPIs et success metrics

### Conversion targets
- **Gratuit → Payant** : 25% Y1, 30% Y2
- **Coach → Expert** : 20% Y1, 25% Y2  
- **Expert → Studio** : 15% Y1, 20% Y2

### Revenue targets
- **ARPU** : €35 Y1, €42 Y2 (mix shift vers plans supérieurs)
- **LTV/CAC** : 5:1 Y1, 7:1 Y2 (retention improvement)
- **Churn mensuel** : <8% Y1, <5% Y2 (industry benchmark 6-10%)

### Pricing success indicators
- **Competitive win rate** : 60%+ vs Trainerize/TrueCoach
- **Price objection rate** : <20% sales calls
- **Annual plan adoption** : 40%+ Y2 (avec discount 15% à introduire)