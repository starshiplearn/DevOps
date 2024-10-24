#==========================================================================================
RELEASE=1.3.0
mkdir -p /tmp/nginx-exporter && cd /tmp/nginx-exporter && \
wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v${RELEASE}/nginx-prometheus-exporter_${RELEASE}_linux_amd64.tar.gz && \
tar -xzvf nginx-prometheus-exporter_${RELEASE}_linux_amd64.tar.gz
cp /tmp/nginx-exporter/nginx-prometheus-exporter /usr/local/bin/ && \
chmod +x /usr/local/bin/nginx-prometheus-exporter && \
cd - && rm -rf /tmp/nginx-exporter

#==========================================================================================
apt update
apt install -y nginx

#Set Nginx Config

#==========================================================================================
cat << EOF > /etc/systemd/system/nginx-exporter.service
[Unit]
Description=Nginx Exporter
Wants=network-online.target
After=network-online.target
[Service]
Type=simple

ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/nginx-prometheus-exporter \
-nginx.scrape-uri=http://127.0.0.1:8080/stub_status
SyslogIdentifier=nginx-exporter
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nginx-exporter --now
sleep 3
systemctl status nginx-exporter

#==========================================================================================