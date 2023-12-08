#==========================================================================================
#Written by 'Mohammad Naghdi' of 'https://starshiplearn.com'
#==========================================================================================
apt update
apt install -y apt-transport-https software-properties-common wget curl

wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list

apt update
apt install -y grafana && \

systemctl enable grafana-server
systemctl start grafana-server
systemctl status grafana-server

grafana-server --version
#==========================================================================================