#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq --raw-output ".username" $CONFIG_PATH)
PASSWORD=$(jq --raw-output ".password" $CONFIG_PATH)

echo "Parameters: $USERNAME@$PASSWORD"

while true; do 
  if ping -c 5 8.8.8.8 &> /dev/null
  then
    echo "Internet Ok"
  else
    echo "Internet KO, starting vodafone autologin"
    python vodafone.py
  fi
  sleep 30
done