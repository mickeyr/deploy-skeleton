# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    config.vm.forward_port 80, 4501
    config.vm.provision :puppet do |puppet|
        puppet.manifest_file = "site.pp"
        puppet.module_path = "manifests/modules"
    end
end
