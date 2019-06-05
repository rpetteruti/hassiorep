#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq --raw-output ".username" $CONFIG_PATH)
PASSWORD=$(jq --raw-output ".password" $CONFIG_PATH)

echo "Parameters: $USERNAME $PASSWORD"

echo "nameserver 192.168.21.254" > /etc/resolv.conf

while true; do 
  if ping -c 2 8.8.8.8 &> /dev/null
  then
    echo "$(date) Internet OK"
  else
    echo "Internet KO, starting vodafone autologin"
    python vodafone.py $USERNAME $PASSWORD || true
  fi
  sleep 30
done
