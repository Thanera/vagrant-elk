#!/bin/bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && apt-get install logstash
#systemctl start logstash.service
systemctl enable logstash.service