#!/bin/bash
echo "Konfiguration wird übertragen."
cat << EOF > /etc/logstash/logstash-simple.conf
input { stdin { } }
output {
  elasticsearch { hosts => ["elasticsearch:9200", "elasticsearch2:9200", "elasticsearch3:9200"] }
  stdout { codec => rubydebug }
}
EOF

echo "Logstash wird neugestartet und Einsatzbereit gemacht"
systemctl restart logstash
