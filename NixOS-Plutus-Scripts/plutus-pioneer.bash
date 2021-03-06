#!/usr/bin/env bash
# Script to clone or update the Plutus Pioneer repository
# Define the destination directory 
DIR='/opt/plutus-pioneer-program'
# Get using git
if test -d "$DIR"; 
  then cd "$DIR" && git pull --ff-only; 
  else git clone https://github.com/input-output-hk/plutus-pioneer-program.git "$DIR"; 
fi
