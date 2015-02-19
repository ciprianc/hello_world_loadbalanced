VAGRANTFILE_API_VERSION = "2"
box_name = 'puppetlabs/ubuntu-14.04-64-nocm'
box_url  = 'https://vagrantcloud.com/puppetlabs/boxes/ubuntu-14.04-64-nocm'
domain   = 'local'

nodes = [
  { :hostname => 'loadbalancer', :ip => '192.168.50.1'},
  { :hostname => 'web-1',        :ip => '192.168.50.10'},
  { :hostname => 'web-2',        :ip => '192.168.50.11'},
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  nodes.each do |node|
    config.vm.define node[:hostname] do |box|
        box.vm.box = box_name
        box.vm.box_url = box_url
        box.vm.hostname = node[:hostname] + '.' + domain
        box.vm.network "private_network", ip: node[:ip], virtualbox__intnet: true
        # try to get each node's memory setting, default to 128
        box.vm.provider :virtualbox do |vb|
            vb.memory = node[:ram] ? node[:ram] : 128
        end
    end
  end

  # try apt-get update, try and install puppet even if update failed
  config.vm.provision "shell",
      inline: "apt-get update ; DEBIAN_FRONTEND=noninteractive apt-get -yq install puppet"

  # provision with puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
  end

end
