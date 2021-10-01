
nodes = [
  { :box => 'roboxes/ubuntu2104', :hostname => 'kibana', :provider => 'hyperv', :network => 'public_network', 
    :bridge => 'Default Switch', :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Kibana', 
    :install => './scripts/kibana_install.sh', :config => './scripts/kibana_config.sh' },
  { :box => 'roboxes/ubuntu2104', :hostname => 'elasticsearch', :provider => 'hyperv', :network => 'public_network', 
    :bridge => 'Default Switch', :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Elasticsearch', 
    :install => './scripts/elasticsearch_install.sh', :config => './scripts/elasticsearch_config.sh' },
  { :box => 'roboxes/ubuntu2104', :hostname => 'elasticsearch2', :provider => 'hyperv', :network => 'public_network', 
    :bridge => 'Default Switch', :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Elasticsearch2', 
    :install => './scripts/elasticsearch_install.sh', :config => './scripts/elasticsearch_config.sh' },
  { :box => 'roboxes/ubuntu2104', :hostname => 'elasticsearch3', :provider => 'hyperv', :network => 'public_network', 
    :bridge => 'Default Switch', :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Elasticsearch3', 
    :install => './scripts/elasticsearch_install.sh', :config => './scripts/elasticsearch_config.sh' },
  { :box => 'roboxes/ubuntu2104', :hostname => 'logstash', :provider => 'hyperv', :network => 'public_network', 
    :bridge => 'Default Switch', :cpus => '4', :memory => '2048', :maxmemory => '4096', :vmname => 'Logstash', 
    :install => './scripts/logstash_install.sh', :config => './scripts/logstash_config.sh' },
]

Vagrant.configure("2") do |config|

  # Netzwerkauflösung 
  config.vagrant.plugins = "vagrant-hostmanager"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|

      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.vm.provider node[:provider]
      nodeconfig.vm.network node[:network], type: "dhcp", bridge: node[:bridge], :use_dhcp_assigned_default_route => true

      if ARGV[0] == "up"
        nodeconfig.vm.provision "shell", path: node[:install], privileged: true
      end

      nodeconfig.vm.provision "shell", path: node[:config], privileged: true

      # Config VirtualBox
      nodeconfig.vm.provider "virtualbox" do |vb|
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
