#==========================================================================================
RELEASE=0.25.0
cd /tmp
wget https://github.com/prometheus/blackbox_exporter/releases/download/v$RELEASE/blackbox_exporter-$RELEASE.linux-amd64.tar.gz
tar xvzf blackbox_exporter-$RELEASE.linux-amd64.tar.gz
mkdir -p /etc/blackbox
cp blackbox_exporter-$RELEASE.linux-amd64/blackbox_exporter /usr/local/bin/
cp blackbox_exporter-$RELEASE.linux-amd64/blackbox.yml /etc/blackbox
chmod +x /usr/local/bin/blackbox_exporter
useradd -rs /bin/false blackbox
chmod +x /usr/local/bin/blackbox_exporter
chown blackbox:blackbox -R /usr/local/bin/blackbox_exporter /etc/blackbox/*
rm -rf blackbox_exporter-$RELEASE.linux-amd64*

#==========================================================================================
cat << EOF > /lib/systemd/system/blackbox.service
[Unit]
Description=Blackbox Exporter Service
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
User=blackbox
Group=blackbox
ExecStart=/usr/local/bin/blackbox_exporter \
--config.file=/etc/blackbox/blackbox.yml \
--web.listen-address=":9115"
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable blackbox --now
sleep 5
systemctl status blackbox
