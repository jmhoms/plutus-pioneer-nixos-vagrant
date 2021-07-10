# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install vagrant-disksize to allow resizing the vagrant box disk.
unless Vagrant.has_plugin?("vagrant-disksize")
    raise  Vagrant::Errors::VagrantError.new, "vagrant-disksize plugin is missing. Please install it using 'vagrant plugin install vagrant-disksize' and rerun 'vagrant up'"
end

Vagrant.configure("2") do |config|
  config.vm.box = "jmhoms/nixos-20.09-x86_64"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 8009, host: 8009
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.disksize.size = '50GB'
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "8192"
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.vm.provision "file", source: "NixOS-Plutus-Scripts", destination: "/home/vagrant/NixOS-Plutus-Scripts"
  config.vm.provision "initial-configure-nix", type: "shell", :path => "NixOS-Plutus-Scripts/apply-initial-configuration.sh", privileged: true 
  config.vm.provision "resize-fs", type: "shell", :path => "NixOS-Plutus-Scripts/resize-fs.sh", privileged: true
  config.vm.provision "plutus", type: "shell", :path => "NixOS-Plutus-Scripts/plutus-pioneer-cohort02-week01.bash", privileged: false
  #config.vm.provision "shell", inline: <<-SHELL
  #   cd /home/vagrant/
  #SHELL
end
