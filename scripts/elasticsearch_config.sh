#!/bin/bash
echo "Konfiguration wird übertragen."
cat << EOF > /etc/elasticsearch/elasticsearch.yml
cluster.name: Dev-Cluster
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
cluster.initial_master_nodes: ["elasticsearch"]
EOF
systemctl restart elasticsearch
echo "Elasticsearch wird neugestartet und Einsatzbereit gemacht"
