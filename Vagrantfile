# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  #config.vm.box = "cartodb"
  #config.vm.box_url = "/Users/markwestra/1_Akvo/1_Dev_Projects/1_FLOW/5_research/2014/cartoDB/vagrant/cartodb-dev/cartodb.box"
  #config.vm.synced_folder ".", "/usr/local/src/cartodb-setup", owner: "ubuntu", group: "ubuntu"
  config.vm.provision :shell, inline:  "cd /vagrant && ./install-cartodb.sh"
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 8181, host: 8181
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 5432, host: 15432
end
