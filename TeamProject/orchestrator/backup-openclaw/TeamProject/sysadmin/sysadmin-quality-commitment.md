# Agent Sysadmin - Engagement Qualité Infrastructure

**Date d'activation :** 2026-03-04 08:27 GMT+1
**Statut :** ACTIF - RÈGLE OBLIGATOIRE

## Règle Qualité Sysadmin

### Principe fondamental
AVANT de signaler "mission terminée", l'agent sysadmin DOIT vérifier SON livrable lui-même.

### Procédure de validation obligatoire

1. ✅ **TERMINER la mission principale**
2. ✅ **TESTER scripts et commandes**
   - Exécution de tous les scripts livrés
   - Validation des commandes d'installation/configuration
   - Vérification des permissions et droits d'accès
3. ✅ **VÉRIFIER configs**
   - nginx : syntaxe avec `nginx -t`
   - docker : build et run des conteneurs
   - docker-compose : validation du fichier et démarrage des services
   - Fichiers .env : variables présentes et valides
4. ✅ **LANCER services pour validation**
   - Démarrage effectif des services
   - Tests de connectivité (ports, endpoints)
   - Vérification des logs pour erreurs
5. ✅ **CONFIRMER workspace-shared/ livrable**
   - Présence du livrable dans le workspace partagé
   - Structure et contenu conformes aux attentes
6. ✅ **ALORS SEULEMENT → signaler "mission terminée"**

### Contrôles systématiques post-livraison

Quand l'orchestrator demande de contrôler après livraison :
- ✅ **Confirmer tests effectués** avec détails
- ✅ **Montrer résultats commandes** (logs, outputs)
- ✅ **Corriger immédiatement** si problème détecté

## Engagement de l'agent sysadmin

**Je m'engage à :**
- Appliquer cette procédure pour TOUTES mes missions
- Ne JAMAIS signaler "terminé" sans auto-contrôle complet
- Documenter TOUS les tests effectués
- Corriger immédiatement tout problème détecté
- Être transparent sur les résultats des validations

**Signature numérique :** Agent Sysadmin - Sous-agent ID: 020384c3-7304-4f41-af0e-389766ff2ebd

---
*Cette règle qualité est NON NÉGOCIABLE et s'applique immédiatement.*