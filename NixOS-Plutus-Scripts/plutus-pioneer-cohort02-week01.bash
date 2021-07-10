#!/usr/bin/env bash
# Plutus setup
# Stop the services if already running from a previous installation
sudo systemctl stop PlutusPlaygroundServer
sudo systemctl stop PlutusPlaygroundClient
# Disable the services during the (re)build
sudo cp /home/vagrant/NixOS-Plutus-Scripts/plutus-services-disabled.nix /etc/nixos/plutus-services.nix
sudo nixos-rebuild switch
# Delete any previous install
if test -d /opt/plutus; then rm -rf /opt/plutus; fi 
# Checkout and Build
if test -d /opt; then cd /opt; else sudo mkdir /opt && sudo chown vagrant /opt && cd /opt; fi
git clone https://github.com/input-output-hk/plutus
cd plutus
git checkout 3746610e53654a1167aeb4c6294c6096d16b0502
nix-shell --run "exit"
nix build -f default.nix plutus.haskell.packages.plutus-core
# Bind client to host 0.0.0.0 instead of localhost to allow access from host browser
cp plutus-playground-client/package.json plutus-playground-client/package.json.bak
sed 's/--mode=development/--mode=development --host 0.0.0.0/g' plutus-playground-client/package.json.bak > plutus-playground-client/package.json
# Enable the services
sudo cp /home/vagrant/NixOS-Plutus-Scripts/plutus-services-enabled.nix /etc/nixos/plutus-services.nix
sudo nixos-rebuild switch
# Start the services
sudo systemctl start PlutusPlaygroundServer
sudo systemctl start PlutusPlaygroundClient
# Come back
cd -
