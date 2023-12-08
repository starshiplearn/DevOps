#==========================================================================================
#Written by 'Mohammad Naghdi' of 'https://starshiplearn.com'
#==========================================================================================
apt update
apt install -y apt-transport-https software-properties-common wget curl

wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list
rm -rf influxdata-archive_compat.key

apt update
apt install -y influxdb2
systemctl start influxdb
systemctl enable influxdb
sleep 5
systemctl status influxdb

curl -sL -I localhost:8086/ping

#influx v1:
#influx -version
#==========================================================================================
#apt install -y influxdb-client
#==========================================================================================