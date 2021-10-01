#!/bin/bash

cat << EOF > /etc/kibana/kibana.yml
server.host: 0.0.0.0
server.name: "elk-kibana"
elasticsearch.hosts: ["http://elasticsearch:9200"]
#elasticsearch.username: "kibana_system"
#elasticsearch.password: "pass"
EOF
systemctl restart kibana