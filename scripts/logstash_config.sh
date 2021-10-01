#!/bin/bash
echo "Konfiguration wird übertragen."
cat << EOF > /etc/logstash/logstash-simple.conf
input { stdin { } }
output {
  elasticsearch { hosts => ["elasticsearch:9200"] }
  stdout { codec => rubydebug }
}
EOF
systemctl restart logstash
echo "Logstash wird neugestartet und Einsatzbereit gemacht"
