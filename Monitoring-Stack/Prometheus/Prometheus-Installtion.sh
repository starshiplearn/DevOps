#==========================================================================================
#Written by 'Mohammad Naghdi' of 'https://starshiplearn.com'
#==========================================================================================
apt update
apt install -y apt-transport-https software-properties-common wget curl

RELEASE="2.47.0"
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${RELEASE}/prometheus-${RELEASE}.linux-amd64.tar.gz
tar xvf prometheus-${RELEASE}.linux-amd64.tar.gz
rm -rf prometheus-${RELEASE}.linux-amd64.tar.gz
cd prometheus-${RELEASE}.linux-amd64

groupadd --system prometheus
useradd -s /sbin/nologin -r -g prometheus prometheus

mkdir -p /etc/prometheus/alerts
mkdir -p /etc/prometheus/files_sd
mkdir -p /var/lib/prometheus

cp prometheus promtool /usr/local/bin/
cp -r consoles/ console_libraries/ /etc/prometheus/
cp prometheus.yml /etc/prometheus/prometheus.yml

cd ..
rm -rf prometheus-${RELEASE}.linux-amd64

#==========================================================================================
#Prometheus Config
cat << EOF > /etc/prometheus/prometheus.yml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).
  external_labels:
    monitor: "my-project"
# Alertmanager configuration
alerting:
  alertmanagers:
    - scheme: http
    - static_configs:
        - targets:
           - localhost:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  - "alerts/*.yml"
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label \`job=<job_name>\` to any timeseries scraped from this config.
############################################
#For Node Exporter
#  - job_name: NodeExporterName
#    static_configs:
#      - targets:
#        - IP:Port
#    metrics_path: /metrics
############################################
EOF

#==========================================================================================
#Prometheus Service
cat << EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.external-url=

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF

#==========================================================================================
#Prometheus Permissios
chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
sleep 5
systemctl status prometheus

#==========================================================================================