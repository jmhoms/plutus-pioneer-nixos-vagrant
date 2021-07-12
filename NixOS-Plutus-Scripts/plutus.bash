#!/usr/bin/env bash
# Script to install or update Plutus 
# Checking parameters 
if [[ $1 == install ]];
then
  echo >&2 "Starting Plutus new install..."
else
  if [[ $1 == update ]];
  then
    echo >&2 "Starting Plutus update..."
  else
    echo >&2 "Usage: plutus.bash {install|update} [commit_id]"
    echo >&2 "Exiting..."
    exit 1
  fi
fi
# Then make sure that we can get the required sources
# Checking /opt
if test -d /opt; then cd /opt; else sudo mkdir /opt && sudo chown vagrant /opt && cd /opt; fi
# Checking if previous temp repository dir exists
if test -d /opt/plutus-new; then rm -rf /opt/plutus-new; fi
# Clone the repository into a temporary directory
git clone https://github.com/input-output-hk/plutus /opt/plutus-new
ret=$?
if ! test "$ret" -eq 0
then
    echo >&2 "git operation failed with exit status $ret"
    exit 1
fi
cd /opt/plutus-new
# If a commit ID is specified check that it actually exists
if [ -z "$2" ]
then
  echo >&2 "No commit ID specified, using HEAD..."
else
  if [ ${#2} -eq 40 ]
  then
    if git log --all --reflog | grep -q $2;
    then
      echo >&2 "Starting checkout of the specified commit ID"
      git checkout $2
      ret=$?
      if ! test "$ret" -eq 0
      then
        echo >&2 "git operation failed with exit status $ret"
        exit 1
      fi
    else
      echo >&2 "Commit ID not found in the repository. Exiting..."
      exit 1
    fi
  else
    echo >&2 "Please provide a valid 40 character commit ID. Exiting..."
    exit 1
  fi
fi
# Once we are sure that we can proceed, stop and disable the services if needed
echo >&2 "Disabling Plutus services..."
sudo systemctl stop PlutusPlaygroundServer
sudo systemctl stop PlutusPlaygroundClient
sudo cp /home/vagrant/NixOS-Plutus-Scripts/plutus-services-disabled.nix /etc/nixos/plutus-services.nix
sudo nixos-rebuild switch
# Start from scratch or update the source depending on the first parameter
echo >&2 "Preparing directory..."
if [[ $1 == install ]];
then
  # if installing
  # remove any previous install
  if test -d /opt/plutus; then rm -rf /opt/plutus; fi
  # use the contents from the temporary directory
  mv /opt/plutus-new /opt/plutus
  cd /opt/plutus
else
  # if not installing we are updating
  # check plutus directory and discard the temporary one
  if test -d /opt/plutus; then cd /opt/plutus && rm -rf /opt/plutus-new; else echo >&2 "Plutus directory not found. Exiting..." && exit 1; fi
  # discard local changes made by the script
  git checkout plutus-playground-client/package.json
  # update the repository
  git pull origin master --ff-only
  ret=$?
  if ! test "$ret" -eq 0
  then
    echo >&2 "git operation failed with exit status $ret"
    exit 1
  fi
  # and checkout to the commit ID that was alredy verified
  if [ -z "$2" ]
  then
    echo >&2 "No commit ID specified, using HEAD..."
  else
    git checkout $2
  fi
fi
# Start build process
nix build -f default.nix plutus.haskell.packages.plutus-core
ret=$?
if ! test "$ret" -eq 0
then
  echo >&2 "Build operation failed with exit status $ret"
  exit 1
fi
# Bind client to host 0.0.0.0 instead of localhost to allow access from host browser
cp plutus-playground-client/package.json plutus-playground-client/package.json.bak
sed 's/--mode=development/--mode=development --host 0.0.0.0/g' plutus-playground-client/package.json.bak > plutus-playground-client/package.json
# Move some of the work to the provision phase
nix-shell --run "exit"
# Enable the services
sudo cp /home/vagrant/NixOS-Plutus-Scripts/plutus-services-enabled.nix /etc/nixos/plutus-services.nix
sudo nixos-rebuild switch
# Start the services
sudo systemctl start PlutusPlaygroundServer
sudo systemctl start PlutusPlaygroundClient
# Return to the initial directory
cd - > /dev/null
