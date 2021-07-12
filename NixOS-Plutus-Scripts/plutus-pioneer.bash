#!/usr/bin/env bash
# Script to clone or update the Plutus Pioneer repository
# Define the destination directory 
DIR='/vagrant/plutus-pioneer-program'
# Get using git
if test -d "$DIR"; 
  then cd "$DIR" && git pull origin master --ff-only && cd - > /dev/null; 
  else git clone https://github.com/input-output-hk/plutus-pioneer-program.git "$DIR"; 
fi
