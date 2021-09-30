# Für die Ausführung muss das Reloadplugin installiert sein
# vagrant plugin install vagrant-reload


$elasticinstall = <<-'SCRIPT'
#!/bin/bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && apt-get install elasticsearch
systemctl start elasticsearch
systemctl enable elasticsearch
date > /etc/vagrant_provisioned_at
SCRIPT

$kibanainstall = <<-'SCRIPT'
#!/bin/bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && apt-get install kibana
systemctl start kibana.service
systemctl enable kibana.service
date > /etc/vagrant_provisioned_at
SCRIPT

$logstashinstall = <<-'SCRIPT'
#!/bin/bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && apt-get install logstash
systemctl start logstash.service
systemctl enable logstash.service
date > /etc/vagrant_provisioned_at
SCRIPT

$configurestaticelastic = <<-'SCRIPT'
#!/bin/sh

echo 'Setting static IP address for Hyper-V...'

cat << EOF > /etc/netplan/02-staticip.yaml
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: no
      addresses: [192.168.100.101/24]
      gateway4: 192.168.0.1
      nameservers:
        addresses: [1.1.1.1]
EOF

# Be sure NOT to execute "netplan apply" here, so the changes take effect on
# reboot instead of immediately, which would disconnect the provisioner.
SCRIPT

$configurestatickibana = <<-'SCRIPT'
#!/bin/sh

echo 'Setting static IP address for Hyper-V...'

cat << EOF > /etc/netplan/02-staticip.yaml
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: no
      addresses: [192.168.100.102/24]
      gateway4: 192.168.0.1
      nameservers:
        addresses: [1.1.1.1]
EOF

# Be sure NOT to execute "netplan apply" here, so the changes take effect on
# reboot instead of immediately, which would disconnect the provisioner.
SCRIPT

$configurestaticlogstash = <<-'SCRIPT'
#!/bin/sh

echo 'Setting static IP address for Hyper-V...'

cat << EOF > /etc/netplan/02-staticip.yaml
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: no
      addresses: [192.168.100.103/24]
      gateway4: 192.168.0.1
      nameservers:
        addresses: [1.1.1.1]
EOF

# Be sure NOT to execute "netplan apply" here, so the changes take effect on
# reboot instead of immediately, which would disconnect the provisioner.
SCRIPT

nodes = [
    { :box => 'roboxes/ubuntu2104', :hostname => 'elk-elasticsearch', :provider => 'hyperv', :network => 'public_network', :bridge => 'Default Switch', :provision => $elasticinstall, :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Elasticsearch', :port => '9200', :ip => '192.168.100.101/24', :staticip => $configurestaticelastic, :staticrun => './scripts/set-hyperv-switch-elasticsearch.ps1' },
    { :box => 'roboxes/ubuntu2104', :hostname => 'elk-kibana', :provider => 'hyperv', :network => 'public_network', :bridge => 'Default Switch', :provision => $kibanainstall, :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Kibana', :port => '5601', :ip => '192.168.100.102/24', :staticip => $configurestatickibana, :staticrun => './scripts/set-hyperv-switch-kibana.ps1' },
    { :box => 'roboxes/ubuntu2104', :hostname => 'elk-logstash', :provider => 'hyperv', :network => 'public_network', :bridge => 'Default Switch', :provision => $logstashinstall, :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Logstash', :port => '9600', :ip => '192.168.100.103/24', :staticip => $configurestaticlogstash, :staticrun => './scripts/set-hyperv-switch-logstash.ps1' },
]

Vagrant.configure("2") do |config|

    # Netzwerkauflösung 
    config.vagrant.plugins = "vagrant-hostmanager"  
    config.vagrant.plugins = "vagrant-reload"    
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    nodes.each do |node|
        config.vm.define node[:hostname] do |nodeconfig|
            nodeconfig.trigger.before :up do |trigger|
                trigger.info = "Creating 'NATSwitch' Hyper-V switch if it does not exist..."
            
                trigger.run = {privileged: "true", powershell_elevated_interactive: "true", path: "./scripts/create-nat-hyperv-switch.ps1"}
            end
            nodeconfig.trigger.after :up do |trigger|
                trigger.info = "Setting Hyper-V switch to 'NATSwitch' to allow for static IP..."
            
                trigger.run = {privileged: "true", powershell_elevated_interactive: "true", path: node[:staticrun]}
            end

            nodeconfig.vm.box = node[:box]
            nodeconfig.vm.hostname = node[:hostname]
            nodeconfig.vm.provider node[:provider]
            nodeconfig.vm.network node[:network], type: "dhcp", bridge: node[:bridge], :use_dhcp_assigned_default_route => true
            nodeconfig.vm.provision "shell", inline: node[:staticip], privileged: true
            #nodeconfig.vm.provision :reload

            #nodeconfig.vm.provision "shell", inline: node[:provision], privileged: true
            nodeconfig.vm.network "forwarded_port", guest: node[:port], host: node[:port]

            # Config for VirtualBox
            nodeconfig.vm.provider "virtualbox" do |vb|
                vb.vm.network :private_network,  ip: node[:ip]
                vb.memory = node[:memory]
                vb.cpus = node[:cpus]
                vb.check_guest_additions = false
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
              end
            
            # Hyper-V settings
            nodeconfig.vm.provider "hyperv" do |hv|
                hv.cpus = node[:cpus]
                hv.memory = node[:memory]
                hv.maxmemory = node[:maxmemory]
                hv.enable_virtualization_extensions = false
                hv.linked_clone = false
                hv.vmname = node[:hostname]
            end
        end
    end
end
