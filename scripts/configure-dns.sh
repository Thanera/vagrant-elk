#!/bin/sh

echo 'Setting static IP address for Hyper-V...'

cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: yes
      nameservers:
        addresses: [1.1.1.1]
EOF