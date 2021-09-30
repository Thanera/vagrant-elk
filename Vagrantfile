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

nodes = [
    { :box => 'roboxes/ubuntu2104', :hostname => 'elk-elasticsearch', :provider => 'hyperv', :network => 'public_network', :bridge => 'extern', :provision => $elasticinstall, :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Elasticsearch', :port => '9200' },
    { :box => 'roboxes/ubuntu2104', :hostname => 'elk-kibana', :provider => 'hyperv', :network => 'public_network', :bridge => 'extern', :provision => $kibanainstall, :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Kibana', :port => '5601' },
    { :box => 'roboxes/ubuntu2104', :hostname => 'elk-logstash', :provider => 'hyperv', :network => 'public_network', :bridge => 'extern', :provision => $logstashinstall, :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Logstash', :port => '9600' },
]

Vagrant.configure("2") do |config|
    nodes.each do |node|
        config.vm.define node[:hostname] do |nodeconfig|
            nodeconfig.vagrant.plugins = "vagrant-hostmanager"
            nodeconfig.vm.box = node[:box]
            nodeconfig.vm.hostname = node[:hostname]
            nodeconfig.vm.provider node[:provider]
            #nodeconfig.ssh.password = "vagrant"
            #nodeconfig.vm.synced_folder "~/vagrant/elastic", "/home/vagrant/"
            nodeconfig.vm.network node[:network], type: "dhcp", bridge: node[:bridge], :use_dhcp_assigned_default_route => true
            #nodeconfig.vm.network "forwarded_port", guest: node[:port], host: node[:port]
            #nodeconfig.vm.provision "shell", path: "./scripts/configure-dns.sh"
           #nodeconfig.vm.provision :reload
            nodeconfig.vm.provision "shell", inline: node[:provision], privileged: true
            #nodeconfig.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            #
            # Netzwerkauflösung 
            nodeconfig.hostmanager.enabled = true
            nodeconfig.hostmanager.manage_host = true
            nodeconfig.hostmanager.manage_guest = true
            nodeconfig.hostmanager.ignore_private_ip = false
            nodeconfig.hostmanager.include_offline = true
            #nodeconfig.hostmanager.aliases = %w(node[:hostname])
            # Config for VirtualBox
            nodeconfig.vm.provider "virtualbox" do |vb|
                vb.memory = node[:memory]
                vb.cpus = node[:cpus]
                vb.check_guest_additions = false
                #vb.vmname = node[:vmname]
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--natdnshostresolver2", "on"]
                #vb.customize ["modifyvm", :id, "--nic2", "bridged", "--bridgeadapter2", "Killer(R) Wi-Fi 6 AX1650s 160MHz Wireless Network Adapter (201D2W)"]
              end
            
            # Hyper-V settings
            nodeconfig.vm.provider "hyperv" do |hv|
                hv.cpus = node[:cpus]
                hv.memory = node[:memory]
                hv.maxmemory = node[:maxmemory]
                hv.enable_virtualization_extensions = false
                hv.linked_clone = false
                hv.vmname = node[:vmname]
                #  h.vm_integration_services = {
                #    guest_service_interface: true,
                #    CustomVMSRV: true
                #  }
            end
        end
    end
    # config.vm.define "kibana" do |kibana|
    #     kibana.vm.box = "roboxes/ubuntu2104"
    #     kibana.vm.hostname = "kibana"
    #     kibana.vm.provider "hyperv"
    #     #kibana.ssh.password = "vagrant"
    #     #kibana.vm.synced_folder "~/vagrant/kibana", "/home/vagrant/"
    #     kibana.vm.network "public_network", bridge: "Default Switch"
    #     kibana.vm.provision "shell", inline: $kibanainstall, privileged: true
    #     config.vm.provider "hyperv" do |h|
    #         h.cpus = 4
    #         h.memory = 2048
    #         h.maxmemory = 4096
    #         h.enable_virtualization_extensions = false
    #         h.linked_clone = false
    #         h.vmname = "kibana"
    #         # h.vm_integration_services = {
    #         #   guest_service_interface: true,
    #         #   CustomVMSRV: true
    #         # }
    #     end
    # end

    # config.vm.define "logstash" do |logstash|
    #     logstash.vm.box = "roboxes/ubuntu2104"
    #     logstash.vm.hostname = "logstash"
    #     logstash.vm.provider "hyperv"
    #     #logstash.ssh.password = "vagrant"
    #     #logstash.vm.synced_folder "~/vagrant/logstash", "/home/vagrant/"
    #     logstash.vm.network "public_network", bridge: "Default Switch"
    #     logstash.vm.provision "shell", inline: $logstashinstall, privileged: true
    #     config.vm.provider "hyperv" do |h|
    #         h.cpus = 4
    #         h.memory = 2048
    #         h.maxmemory = 4096
    #         h.enable_virtualization_extensions = false
    #         h.linked_clone = false
    #         h.vmname = "logstash"
    #         # h.vm_integration_services = {
    #         #   guest_service_interface: true,
    #         #   CustomVMSRV: true
    #         # }
    #     end
    # end

end
