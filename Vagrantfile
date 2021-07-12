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
  config.disksize.size = '35GB' # Minumum required is around 20GB, but additional builds may require more
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "8192" # Minimum required is 8GB according to many sources   
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.vm.provision "file", source: "NixOS-Plutus-Scripts", destination: "/home/vagrant/NixOS-Plutus-Scripts"
  config.vm.provision "set-scripts-perms", type: "shell", :path => "NixOS-Plutus-Scripts/set-scripts-perms.sh", privileged: false 
  config.vm.provision "initial-configure-nix", type: "shell", :path => "NixOS-Plutus-Scripts/apply-initial-configuration.sh", privileged: true 
  config.vm.provision "resize-fs", type: "shell", :path => "NixOS-Plutus-Scripts/resize-fs.sh", privileged: true
  config.vm.provision "plutus", type: "shell", :path => "NixOS-Plutus-Scripts/plutus-cohort02-week01.bash", privileged: false
  config.vm.provision "plutus", type: "shell", :path => "NixOS-Plutus-Scripts/plutus-pioneer.bash", privileged: false
  config.vm.provision "shell", inline: <<-SHELL
    echo "Provisioning finished. Run "vagrant ssh" to login into the system."
    echo "Be aware that Plutus services may take some minutes to start."
    echo "To check the service status:"
    echo "  systemctl status PlutusPlaygroundServer"
    echo "  systemctl status PlutusPlaygroundClient"
    echo "  journalctl -f -u PlutusPlaygroundServer"
    echo "  journalctl -f -u PlutusPlaygroundClient"
    echo "Once started, they will be accesible via tcp ports 8080 (server) and 8009 (client)."
    echo "To check if the ports are available:"
    echo "  netstat -an |grep -e 8080 -e 8009"
    echo "Once available, access the service pointing your browser to the url:"
    echo "  https://127.0.0.1:8009"
    echo "Accept any certificate warning in order to move forward."
    echo "The code for the pioneer program can be located in /vagrant, and accesed from host."
    echo "Example commands to compile a project (from the vm shell):"
    echo "  cd /opt/plutus"
    echo "  nix-shell"
    echo "  cd /vagrant/plutus-pioneer-program/code/week01/"
    echo "  cabal update (only first time)"
    echo "  cabal build"
    echo "Enjoy!"
  SHELL
end
