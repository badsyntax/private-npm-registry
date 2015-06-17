# -*- mode: ruby -*-
# vi: set ft=ruby :

print "Updating submodules...\n"
`git submodule update --init --recursive`

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "provision.sh"
  config.vm.network "private_network", ip: "192.168.50.4"
end
