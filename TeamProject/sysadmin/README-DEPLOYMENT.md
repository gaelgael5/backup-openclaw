# Deployment Infrastructure - SYSADMIN v2.0

## Overview
Infrastructure complète de déploiement autonome avec stratégies blue-green, canary et disaster recovery.

## Secrets requis
```
DATABASE_URL=postgresql://user:pass@host:5432/db
GRAFANA_PASSWORD=secure_password
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
```

## Workflows disponibles

### 1. Production Deploy
- **Trigger**: Push sur main ou manual dispatch
- **Stratégies**: Blue-Green (défaut), Canary, Rolling
- **Rollback**: Automatique en cas d'échec

### 2. Disaster Recovery
- **Trigger**: Manual dispatch uniquement
- **Restaure**: Base de données + données applicatives
- **Target**: staging ou prod-recovery

## Commandes rapides

```bash
# Validation locale
./validate-deployment.sh

# Deploy staging
gh workflow run "Production Deploy Pipeline" -f environment=staging

# Deploy production blue-green
gh workflow run "Production Deploy Pipeline" -f environment=production -f strategy=blue-green

# Disaster recovery
gh workflow run "Disaster Recovery" -f backup_date=20260305 -f target_env=staging
```

## Monitoring
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/GRAFANA_PASSWORD)

## Runbook incidents
1. **App down**: Vérifier health checks → rollback si nécessaire
2. **Database issues**: Déclencher disaster recovery
3. **Traffic issues**: Vérifier load balancer → switch Blue/Green
