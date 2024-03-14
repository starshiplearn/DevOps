#==========================================================================================
#NodeExporter Installtion
VERSION=1.7.0
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz && \
tar -xzvf node_exporter-${VERSION}.linux-amd64.tar.gz && \
mv /tmp/node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/node_exporter && \
rm -r node_exporter-${VERSION}.linux-amd64 && \
rm -r node_exporter-${VERSION}.linux-amd64.tar.gz && \
echo "node_exporter is Installed" && \
echo "========================" && \
echo "Node Exporter Installed."

#==========================================================================================



