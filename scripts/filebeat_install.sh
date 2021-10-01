#!/bin/bash

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.15.0-amd64.deb
sudo dpkg -i filebeat-7.15.0-amd64.deb

echo "Konfiguration wird übertragen."
cat << EOF > /etc/filebeat/filebeat.yml
output.elasticsearch:
  hosts: ["elasticsearch:9200", "elasticsearch2:9200", "elasticsearch3:9200"]
  username: "elastic"
  password: "changeme"
setup.kibana:
  host: "kibana:5601"
EOF

# Enable Modules
filebeat modules enable auditd
filebeat modules enable elasticsearch
filebeat modules enable kibana
filebeat modules enable nginx

# Konfigure and start Filebeat
filebeat setup
systemctl start filebeat