#==========================================================================================
#NodeExporter Service
cat << EOF > /lib/systemd/system/node-exporter.service
[Unit]
Description=Linux Node Exporter (Prometheus Datasource)
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF

#------------------------------------------------------------------------------------------
systemctl daemon-reload
systemctl enable node-exporter 
systemctl start node-exporter
sleep 5
systemctl status node-exporter
#==========================================================================================