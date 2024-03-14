#==========================================================================================
cat << EOF >> /etc/prometheus/prometheus.yml
#===========================================
#For Node Exporter
  - job_name: NodeExporter
    static_configs:
      - targets:
        - monitor.starshiplearn.com:9100
    metrics_path: /metrics
EOF

#------------------------------------------------------------------------------------------
#for host
#systemctl restart prometheus
#sleep 5
#systemctl status prometheus
#------------------------------------------------------------------------------------------
#for Container
#docker restart prometheus
===========================================================================================