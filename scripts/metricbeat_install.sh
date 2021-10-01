#!/bin/bash

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/metricbeat-7.15.0-amd64.deb
sudo dpkg -i metricbeat-7.15.0-amd64.deb

echo "Konfiguration wird übertragen."
cat << EOF > /etc/metricbeat/metricbeat.yml
output.elasticsearch:
  hosts: ["elasticsearch:9200", "elasticsearch2:9200", "elasticsearch3:9200"]
  username: "elastic"
  password: "changeme"
setup.kibana:
  host: "kibana:5601"
EOF

# Enable Modules
metricbeat modules enable elasticsearch
metricbeat modules enable kibana
metricbeat modules enable logstash
metricbeat modules enable nginx
metricbeat modules enable system

# Konfigure and start Metricbeat
metricbeat setup
systemctl start metricbeat