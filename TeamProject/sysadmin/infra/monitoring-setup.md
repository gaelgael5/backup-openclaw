# Setup Monitoring & Alerting - MyCoach Infrastructure

**Date**: 2026-03-02  
**Responsable**: Sysadmin OpenClaw  
**Objectif**: Superviser l'infrastructure, détecter les problèmes et alerter l'équipe

---

## 🎯 **OBJECTIFS DE MONITORING**

### **SLA Targets**
- **Uptime**: 99.9% (8.76h downtime/an)
- **Performance**: API response time < 2s (P95)
- **Availability**: Health check success > 99.5%
- **Recovery**: MTTR (Mean Time To Recovery) < 30 minutes

### **Métriques Critiques**
1. **Infrastructure** : CPU, RAM, Disk, Network
2. **Application** : Response time, Error rate, Throughput  
3. **Base de données** : Connections, Query time, Locks
4. **Sécurité** : Failed logins, SSL cert expiry, Intrusion attempts
5. **Business** : User signups, API usage, Revenue impact

---

## 🏗️ **ARCHITECTURE MONITORING**

```
[MyCoach App] → [Prometheus] → [Grafana Dashboard]
     ↓              ↓              ↓
[Node Exporter] → [AlertManager] → [Discord/Email/PagerDuty]
     ↓              ↓              ↓  
[Log Aggregation] → [ELK Stack] → [Security Alerts]
```

### **Stack Technologique**
- **Métriques** : Prometheus + Grafana
- **Logs** : ELK Stack (Elasticsearch, Logstash, Kibana)
- **Uptime** : Uptime Kuma ou UptimeRobot
- **APM** : Sentry pour error tracking
- **Alerting** : AlertManager + Discord/Slack webhooks

---

## 📊 **PROMETHEUS SETUP**

### **Configuration Docker Compose**
```yaml
# monitoring/docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus/rules:/etc/prometheus/rules
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=90d'
      - '--web.enable-lifecycle'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/dashboards:/var/lib/grafana/dashboards
      - ./grafana/provisioning:/etc/grafana/provisioning
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=secure_password_here
      - GF_USERS_ALLOW_SIGN_UP=false
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager_data:/alertmanager
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:
  alertmanager_data:
```

### **Configuration Prometheus**
```yaml
# prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

scrape_configs:
  # Prometheus lui-même
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter (système)
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  # MyCoach API metrics
  - job_name: 'mycoach-api'
    static_configs:
      - targets: ['192.168.10.63:8200']
    metrics_path: '/metrics'
    scrape_interval: 30s

  # PostgreSQL
  - job_name: 'postgres'
    static_configs:
      - targets: ['192.168.10.63:9187']

  # Nginx
  - job_name: 'nginx'
    static_configs:
      - targets: ['192.168.10.63:9113']

  # Blackbox probes (uptime)
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - http://192.168.10.63:8200/health
        - https://api.mycoach.com/health  # Post HTTPS
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115
```

---

## 🚨 **ALERTING CONFIGURATION**

### **AlertManager Setup**
```yaml
# alertmanager/alertmanager.yml
global:
  smtp_smarthost: 'localhost:587'
  smtp_from: 'alerts@mycoach.com'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'team-discord'
  routes:
  - match:
      severity: critical
    receiver: 'pagerduty'
  - match:
      severity: warning
    receiver: 'team-discord'

receivers:
- name: 'team-discord'
  webhook_configs:
  - url: 'https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_TOKEN'
    send_resolved: true
    title: 'MyCoach Alert'
    text: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'

- name: 'pagerduty'
  pagerduty_configs:
  - routing_key: 'YOUR_PAGERDUTY_KEY'
    description: 'Critical alert on MyCoach infrastructure'

- name: 'team-email'
  email_configs:
  - to: 'sysadmin@mycoach.com'
    subject: '[MyCoach] {{ .GroupLabels.alertname }}'
    body: |
      {{ range .Alerts }}
      Alert: {{ .Annotations.summary }}
      Instance: {{ .Labels.instance }}
      Value: {{ .Annotations.description }}
      {{ end }}
```

### **Règles d'Alerte**
```yaml
# prometheus/rules/alerts.yml
groups:
- name: infrastructure
  rules:
  # Instance down
  - alert: InstanceDown
    expr: up == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Instance {{ $labels.instance }} is down"
      description: "{{ $labels.instance }} has been down for more than 1 minute"

  # High CPU usage
  - alert: HighCPUUsage
    expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage on {{ $labels.instance }}"
      description: "CPU usage is above 80% for 5 minutes"

  # High memory usage
  - alert: HighMemoryUsage
    expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90
    for: 2m
    labels:
      severity: critical
    annotations:
      summary: "High memory usage on {{ $labels.instance }}"
      description: "Memory usage is above 90%"

  # Disk space low
  - alert: DiskSpaceLow
    expr: (1 - (node_filesystem_avail_bytes{fstype!~"tmpfs|fuse.lxcfs"} / node_filesystem_size_bytes)) * 100 > 85
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "Disk space low on {{ $labels.instance }}"
      description: "Disk usage is above 85% on {{ $labels.mountpoint }}"

- name: application
  rules:
  # API response time
  - alert: APIHighResponseTime
    expr: histogram_quantile(0.95, http_request_duration_seconds_bucket{job="mycoach-api"}) > 2
    for: 3m
    labels:
      severity: warning
    annotations:
      summary: "API response time is high"
      description: "95th percentile response time is above 2 seconds"

  # High error rate
  - alert: APIHighErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
    for: 2m
    labels:
      severity: critical
    annotations:
      summary: "High API error rate"
      description: "Error rate is above 5% for 2 minutes"

  # PostgreSQL connections
  - alert: PostgreSQLHighConnections
    expr: pg_stat_database_numbackends / pg_settings_max_connections * 100 > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "PostgreSQL high connection usage"
      description: "Connection usage is above 80%"

- name: security
  rules:
  # SSL certificate expiry
  - alert: SSLCertExpiringSoon
    expr: probe_ssl_earliest_cert_expiry - time() < 86400 * 30
    for: 1h
    labels:
      severity: warning
    annotations:
      summary: "SSL certificate expiring soon"
      description: "SSL certificate for {{ $labels.instance }} expires in less than 30 days"

  # Failed login attempts
  - alert: HighFailedLogins
    expr: rate(mycoach_failed_logins_total[5m]) > 0.1
    for: 3m
    labels:
      severity: warning
    annotations:
      summary: "High number of failed login attempts"
      description: "Failed login rate is above 0.1/sec"
```

---

## 📊 **GRAFANA DASHBOARDS**

### **Dashboard Infrastructure**
```json
{
  "dashboard": {
    "title": "MyCoach Infrastructure",
    "panels": [
      {
        "title": "System Overview",
        "type": "stat",
        "targets": [
          {"expr": "up", "legendFormat": "Services Up"},
          {"expr": "100 - (avg(irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)", "legendFormat": "CPU Usage %"},
          {"expr": "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100", "legendFormat": "Memory Usage %"}
        ]
      },
      {
        "title": "API Response Time",
        "type": "graph",
        "targets": [
          {"expr": "histogram_quantile(0.50, http_request_duration_seconds_bucket)", "legendFormat": "P50"},
          {"expr": "histogram_quantile(0.95, http_request_duration_seconds_bucket)", "legendFormat": "P95"},
          {"expr": "histogram_quantile(0.99, http_request_duration_seconds_bucket)", "legendFormat": "P99"}
        ]
      },
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {"expr": "rate(http_requests_total[5m])", "legendFormat": "Requests/sec"},
          {"expr": "rate(http_requests_total{status=~\"5..\"}[5m])", "legendFormat": "Errors/sec"}
        ]
      }
    ]
  }
}
```

### **Dashboard Application**
```json
{
  "dashboard": {
    "title": "MyCoach Application Metrics", 
    "panels": [
      {
        "title": "User Activity",
        "type": "graph",
        "targets": [
          {"expr": "mycoach_active_users_total", "legendFormat": "Active Users"},
          {"expr": "rate(mycoach_user_registrations_total[1h])", "legendFormat": "New Registrations/h"}
        ]
      },
      {
        "title": "API Endpoints Performance",
        "type": "table",
        "targets": [
          {"expr": "avg by (endpoint) (http_request_duration_seconds)", "format": "table"}
        ]
      },
      {
        "title": "Database Performance",
        "type": "graph", 
        "targets": [
          {"expr": "pg_stat_database_tup_inserted", "legendFormat": "Inserts/sec"},
          {"expr": "pg_stat_database_tup_updated", "legendFormat": "Updates/sec"},
          {"expr": "pg_locks_count", "legendFormat": "Active Locks"}
        ]
      }
    ]
  }
}
```

---

## 📝 **LOG AGGREGATION**

### **ELK Stack Setup**
```yaml
# logging/docker-compose.yml
version: '3.8'

services:
  elasticsearch:
    image: elasticsearch:8.5.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.security.enabled=false
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    restart: unless-stopped

  logstash:
    image: logstash:8.5.0
    container_name: logstash
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline
      - ./logstash/config:/usr/share/logstash/config
    ports:
      - "5044:5044"
      - "9600:9600"
    depends_on:
      - elasticsearch
    restart: unless-stopped

  kibana:
    image: kibana:8.5.0
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    restart: unless-stopped

  filebeat:
    image: docker.elastic.co/beats/filebeat:8.5.0
    container_name: filebeat
    user: root
    volumes:
      - ./filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /opt/mycoach/logs:/opt/mycoach/logs:ro
    depends_on:
      - logstash
    restart: unless-stopped

volumes:
  elasticsearch_data:
```

### **Configuration Filebeat**
```yaml
# filebeat/filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /opt/mycoach/logs/*.log
  fields:
    service: mycoach-api
    environment: production
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after

- type: container
  enabled: true
  paths:
    - '/var/lib/docker/containers/*/*.log'
  processors:
    - add_docker_metadata:
        host: "unix:///var/run/docker.sock"

output.logstash:
  hosts: ["logstash:5044"]

logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
```

### **Pipeline Logstash**
```ruby
# logstash/pipeline/mycoach.conf
input {
  beats {
    port => 5044
  }
}

filter {
  # Parse FastAPI logs
  if [fields][service] == "mycoach-api" {
    grok {
      match => { 
        "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}"
      }
    }
    
    date {
      match => [ "timestamp", "yyyy-MM-dd HH:mm:ss,SSS" ]
    }
  }

  # Parse Nginx access logs
  if [container][name] == "nginx" {
    grok {
      match => {
        "message" => "%{NGINXACCESS}"
      }
    }
    
    mutate {
      convert => { "response" => "integer" }
      convert => { "bytes" => "integer" }
      convert => { "response_time" => "float" }
    }
  }

  # Detect suspicious patterns
  if [request] =~ /\.\./  or [request] =~ /<script>/ {
    mutate {
      add_tag => ["security_alert"]
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "mycoach-logs-%{+YYYY.MM.dd}"
  }
}
```

---

## 🔔 **UPTIME MONITORING**

### **Uptime Kuma Setup**
```yaml
# uptime/docker-compose.yml
version: '3.8'

services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    ports:
      - "3001:3001"
    volumes:
      - uptime_data:/app/data
    restart: unless-stopped

volumes:
  uptime_data:
```

### **Monitors Configuration**
```javascript
// Configuration programmatique via API
const monitors = [
  {
    name: "MyCoach API Health",
    type: "http",
    url: "https://api.mycoach.com/health",
    interval: 60,
    expectedStatus: 200
  },
  {
    name: "MyCoach API Auth",
    type: "http",
    url: "https://api.mycoach.com/auth/me",
    interval: 300,
    headers: {"X-API-Key": "monitoring-key"}
  },
  {
    name: "PostgreSQL",
    type: "port", 
    hostname: "192.168.10.63",
    port: 5432,
    interval: 120
  },
  {
    name: "Grafana Dashboard",
    type: "http",
    url: "http://192.168.10.63:3000/login",
    interval: 300
  }
];
```

---

## 🔒 **SECURITY MONITORING**

### **Fail2Ban Configuration**
```ini
# /etc/fail2ban/jail.local
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5
backend = systemd

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
logpath = /opt/mycoach/logs/nginx/error.log
maxretry = 3

[mycoach-api-auth]
enabled = true
filter = mycoach-api-auth
logpath = /opt/mycoach/logs/app.log
maxretry = 5
bantime = 1800

# Custom filter pour MyCoach API
[Definition]
failregex = ^.*Authentication failed for.*<HOST>.*$
            ^.*Invalid API key from.*<HOST>.*$
ignoreregex =
```

### **Security Metrics dans Prometheus**
```python
# Dans l'app FastAPI - metrics.py
from prometheus_client import Counter, Histogram, Gauge

# Métriques de sécurité
failed_logins = Counter('mycoach_failed_logins_total', 'Total failed login attempts', ['ip'])
blocked_requests = Counter('mycoach_blocked_requests_total', 'Total blocked requests', ['reason'])
active_sessions = Gauge('mycoach_active_sessions', 'Current active user sessions')
ssl_cert_expiry = Gauge('mycoach_ssl_cert_expiry_days', 'Days until SSL cert expiry')

# Middleware pour capturer les métriques
@app.middleware("http")
async def metrics_middleware(request: Request, call_next):
    start_time = time.time()
    
    response = await call_next(request)
    
    # Enregistrer failed logins
    if request.url.path == "/auth/login" and response.status_code == 401:
        client_ip = request.client.host
        failed_logins.labels(ip=client_ip).inc()
    
    # Response time
    duration = time.time() - start_time
    request_duration.labels(
        method=request.method,
        endpoint=request.url.path,
        status=response.status_code
    ).observe(duration)
    
    return response
```

---

## 📱 **NOTIFICATION CHANNELS**

### **Discord Integration**
```python
# scripts/discord_alert.py
import requests
import json

def send_discord_alert(webhook_url, alert_data):
    """
    Envoie une alerte vers Discord
    """
    embed = {
        "embeds": [{
            "title": f"🚨 {alert_data['alertname']}",
            "description": alert_data['annotations']['summary'],
            "color": 16711680 if alert_data['labels']['severity'] == 'critical' else 16776960,
            "fields": [
                {"name": "Instance", "value": alert_data['labels']['instance'], "inline": True},
                {"name": "Severity", "value": alert_data['labels']['severity'], "inline": True},
                {"name": "Started", "value": alert_data['startsAt'], "inline": True}
            ],
            "footer": {"text": "MyCoach Monitoring"}
        }]
    }
    
    response = requests.post(webhook_url, json=embed)
    return response.status_code == 204

# Webhook pour AlertManager
@app.post("/webhook/discord")
async def discord_webhook(alerts: list):
    webhook_url = "https://discord.com/api/webhooks/YOUR_WEBHOOK"
    
    for alert in alerts:
        send_discord_alert(webhook_url, alert)
    
    return {"status": "sent"}
```

### **Slack Integration**
```python
# scripts/slack_alert.py
def send_slack_alert(webhook_url, alert_data):
    """
    Envoie une alerte vers Slack
    """
    severity_emoji = "🔴" if alert_data['labels']['severity'] == 'critical' else "🟡"
    
    message = {
        "text": f"{severity_emoji} MyCoach Alert",
        "attachments": [{
            "color": "danger" if alert_data['labels']['severity'] == 'critical' else "warning",
            "fields": [
                {"title": "Alert", "value": alert_data['alertname'], "short": True},
                {"title": "Instance", "value": alert_data['labels']['instance'], "short": True},
                {"title": "Summary", "value": alert_data['annotations']['summary'], "short": False}
            ],
            "footer": "MyCoach Monitoring",
            "ts": int(time.time())
        }]
    }
    
    response = requests.post(webhook_url, json=message)
    return response.status_code == 200
```

---

## 🎯 **BUSINESS METRICS**

### **Métriques Métier Personnalisées**
```python
# Dans l'application FastAPI
from prometheus_client import Counter, Histogram, Gauge, Info

# Métriques business
user_registrations = Counter('mycoach_user_registrations_total', 'Total user registrations', ['role'])
bookings_created = Counter('mycoach_bookings_total', 'Total bookings created', ['status'])
payments_processed = Counter('mycoach_payments_total', 'Total payments processed', ['method'])
active_coaches = Gauge('mycoach_active_coaches', 'Number of active coaches')
active_clients = Gauge('mycoach_active_clients', 'Number of active clients')

# Endpoints pour exposer business metrics
@app.get("/metrics/business")
async def business_metrics():
    # Update gauges
    active_coaches.set(await get_active_coaches_count())
    active_clients.set(await get_active_clients_count())
    
    return {"status": "metrics updated"}

# Middleware pour capturer business events
@app.middleware("http")
async def business_metrics_middleware(request: Request, call_next):
    response = await call_next(request)
    
    # Track registrations
    if request.url.path == "/auth/register" and response.status_code == 201:
        user_data = await request.json()
        user_registrations.labels(role=user_data.get('role', 'unknown')).inc()
    
    # Track bookings
    if request.url.path == "/bookings" and response.status_code == 201:
        bookings_created.labels(status="created").inc()
    
    return response
```

### **Dashboard Business**
```json
{
  "dashboard": {
    "title": "MyCoach Business Metrics",
    "panels": [
      {
        "title": "User Growth",
        "type": "graph",
        "targets": [
          {"expr": "rate(mycoach_user_registrations_total[1d])", "legendFormat": "Daily Registrations"},
          {"expr": "mycoach_active_coaches", "legendFormat": "Active Coaches"},
          {"expr": "mycoach_active_clients", "legendFormat": "Active Clients"}
        ]
      },
      {
        "title": "Revenue Tracking", 
        "type": "stat",
        "targets": [
          {"expr": "sum(rate(mycoach_payments_total[1d]))", "legendFormat": "Daily Payments"},
          {"expr": "sum(mycoach_booking_revenue_total)", "legendFormat": "Total Revenue"}
        ]
      }
    ]
  }
}
```

---

## 📊 **REPORTING & ANALYTICS**

### **Rapport Automatique Hebdomadaire**
```python
#!/usr/bin/env python3
# scripts/weekly_report.py

import requests
import json
from datetime import datetime, timedelta
from email.mime.text import MIMEText
import smtplib

def generate_weekly_report():
    """
    Génère un rapport hebdomadaire automatique
    """
    end_time = datetime.now()
    start_time = end_time - timedelta(days=7)
    
    # Requêtes Prometheus
    prometheus_url = "http://localhost:9090/api/v1/query_range"
    
    metrics = {
        "uptime": f"avg_over_time(up[7d])",
        "avg_response_time": f"avg_over_time(http_request_duration_seconds[7d])",
        "total_requests": f"increase(http_requests_total[7d])",
        "error_rate": f"increase(http_requests_total{{status=~'5..'}}[7d])",
        "new_users": f"increase(mycoach_user_registrations_total[7d])"
    }
    
    report_data = {}
    for metric_name, query in metrics.items():
        response = requests.get(prometheus_url, params={
            "query": query,
            "start": start_time.isoformat(),
            "end": end_time.isoformat(),
            "step": "1h"
        })
        report_data[metric_name] = response.json()
    
    # Générer rapport HTML/text
    report = generate_html_report(report_data, start_time, end_time)
    
    # Envoyer par email
    send_email_report(report)
    
    return report

def generate_html_report(data, start_time, end_time):
    """
    Génère un rapport HTML stylé
    """
    html = f"""
    <html>
    <head><title>MyCoach Weekly Report</title></head>
    <body>
        <h1>MyCoach Infrastructure Report</h1>
        <h2>Period: {start_time.strftime('%Y-%m-%d')} to {end_time.strftime('%Y-%m-%d')}</h2>
        
        <h3>📊 Key Metrics</h3>
        <ul>
            <li>🟢 Uptime: {data['uptime']:.2%}</li>
            <li>⚡ Avg Response Time: {data['avg_response_time']:.2f}s</li> 
            <li>📈 Total Requests: {data['total_requests']:,.0f}</li>
            <li>❌ Error Rate: {data['error_rate']:.2%}</li>
            <li>👥 New Users: {data['new_users']:,.0f}</li>
        </ul>
        
        <h3>🎯 SLA Compliance</h3>
        <p>{'✅ SLA met' if data['uptime'] >= 0.999 else '❌ SLA missed'}</p>
        
        <h3>📈 Grafana Dashboards</h3>
        <a href="http://192.168.10.63:3000">View Live Dashboard</a>
    </body>
    </html>
    """
    return html

# Cron job hebdomadaire
# 0 9 * * 1 /opt/scripts/weekly_report.py
```

---

## 🔧 **INSTALLATION & DÉPLOIEMENT**

### **Script d'Installation Automatique**
```bash
#!/bin/bash
# install-monitoring.sh

set -e

MONITORING_DIR="/opt/mycoach/monitoring"
echo "🚀 Installing MyCoach Monitoring Stack"

# Créer structure
mkdir -p $MONITORING_DIR/{prometheus,grafana,alertmanager,elk,uptime}
cd $MONITORING_DIR

# Télécharger configs
echo "📥 Downloading configurations..."
wget -O docker-compose.yml https://raw.githubusercontent.com/mycoach/infra/main/monitoring/docker-compose.yml
wget -O prometheus/prometheus.yml https://raw.githubusercontent.com/mycoach/infra/main/monitoring/prometheus.yml

# Générer mots de passe sécurisés
GRAFANA_PASSWORD=$(openssl rand -base64 32)
echo "Grafana admin password: $GRAFANA_PASSWORD" > .secrets

# Démarrer services
echo "🐳 Starting monitoring services..."
docker-compose up -d

# Attendre que les services soient prêts
echo "⏳ Waiting for services to be ready..."
sleep 30

# Configurer dashboards Grafana
echo "📊 Importing Grafana dashboards..."
curl -X POST \
  http://admin:$GRAFANA_PASSWORD@localhost:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -d @dashboards/infrastructure.json

# Configurer alertes
echo "🚨 Setting up alerts..."
curl -X POST \
  http://localhost:9090/-/reload

# Tests de connectivité
echo "🧪 Testing connectivity..."
curl -f http://localhost:9090/targets
curl -f http://localhost:3000/api/health

echo "✅ Monitoring stack installed successfully!"
echo "🔗 Access URLs:"
echo "  - Prometheus: http://localhost:9090"
echo "  - Grafana: http://localhost:3000 (admin/$GRAFANA_PASSWORD)"
echo "  - AlertManager: http://localhost:9093"
```

### **Configuration Post-Installation**
```bash
#!/bin/bash
# configure-monitoring.sh

# Configurer retention Prometheus
sed -i 's/--storage.tsdb.retention.time=15d/--storage.tsdb.retention.time=90d/' docker-compose.yml

# Configurer reverse proxy Nginx pour monitoring
cat > /etc/nginx/sites-available/monitoring << EOF
server {
    listen 80;
    server_name monitoring.mycoach.com;
    
    location /prometheus/ {
        proxy_pass http://localhost:9090/;
        auth_basic "Monitoring";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
    
    location /grafana/ {
        proxy_pass http://localhost:3000/;
        proxy_set_header Host \$host;
    }
}
EOF

# Créer utilisateurs monitoring
htpasswd -c /etc/nginx/.htpasswd admin

# Activer site
ln -s /etc/nginx/sites-available/monitoring /etc/nginx/sites-enabled/
systemctl reload nginx

echo "✅ Monitoring configured with Nginx reverse proxy"
```

---

## 📋 **CHECKLIST DÉPLOIEMENT**

### **Pré-installation**
- [ ] Docker et docker-compose installés
- [ ] Ports 3000, 9090, 9093 disponibles  
- [ ] Espace disque suffisant (>50GB pour logs)
- [ ] Accès réseau vers API MyCoach
- [ ] Webhooks Discord/Slack configurés

### **Installation**
- [ ] Stack Prometheus/Grafana déployée
- [ ] Node Exporter sur tous les serveurs
- [ ] Règles d'alerte configurées
- [ ] Dashboards importés
- [ ] AlertManager testé

### **Configuration**
- [ ] Métriques application exportées
- [ ] Logs centralisés dans ELK
- [ ] Uptime monitoring actif
- [ ] Notifications testées
- [ ] Retention des données configurée

### **Tests**
- [ ] Alertes critiques testées
- [ ] Dashboards accessibles
- [ ] Métriques collectées correctement
- [ ] Logs parsés et indexés
- [ ] Rapports automatiques fonctionnels

---

## 🚨 **RUNBOOK INCIDENTS**

### **Procédure d'Incident P0 (Critical)**
1. **Détection** : Alert reçue via PagerDuty/Discord
2. **Triage** : Vérifier dashboard Grafana
3. **Escalade** : Notifier équipe si >15min
4. **Investigation** : Logs Kibana + métriques Prometheus  
5. **Mitigation** : Rollback ou fix immédiat
6. **Communication** : Status page + stakeholders
7. **Post-mortem** : Documentation cause racine

### **Contacts d'Urgence**
- **SysAdmin Principal** : sysadmin@mycoach.com
- **DevOps** : devops@mycoach.com  
- **CTO** : cto@mycoach.com
- **PagerDuty** : https://mycoach.pagerduty.com

---

**Félicitations !** Le monitoring MyCoach est maintenant opérationnel. Consultez les dashboards Grafana pour superviser l'infrastructure en temps réel.