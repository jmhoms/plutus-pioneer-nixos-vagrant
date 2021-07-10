sudo cp /home/vagrant/NixOS-Plutus-Scripts/configuration.nix /etc/nixos/configuration.nix
sudo cp /home/vagrant/NixOS-Plutus-Scripts/plutus-services-disabled.nix /etc/nixos/plutus-services.nix
sudo nix-channel --update nixos
sudo nixos-rebuild switch
sudo mkdir -p /opt
sudo chown vagrant /opt
sleep 5
