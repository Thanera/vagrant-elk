#!/bin/bash
echo "Konfiguration wird übertragen."
cat << EOF > /etc/kibana/kibana.yml
server.host: 0.0.0.0
server.name: "elk-kibana"
elasticsearch.hosts: ["http://elasticsearch:9200", "http://elasticsearch2:9200", "http://elasticsearch3:9200"]
#elasticsearch.username: "kibana_system"
#elasticsearch.password: "pass"
EOF

echo "Kibana wird neugestartet und Einsatzbereit gemacht"
systemctl restart kibana