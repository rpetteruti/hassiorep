#!/bin/bash
#set -e

#CONFIG_PATH=/data/options.json

#TUYAPLUGIP=$(jq --raw-output ".tuyaplugip" $CONFIG_PATH)

echo "Parameters: $TUYAPLUGIP "

#echo "nameserver ${DNS}" > /etc/resolv.conf
echo "Wait 240s before start loop"
sleep 240
echo "starting loop"
while true; do
  if ping -c 10 8.8.8.8 &> /dev/null
  then
    echo "$(date) Internet OK"
  else
    echo "$(date) Internet KO, starting REBOOT the modem and wait 30s"
    curl "http://$TUYAPLUGIP/cm?cmnd=Power%20Off"
    sleep 30
    curl "http://$TUYAPLUGIP/cm?cmnd=Power%20On"
    echo "Wait 240s before checking again"
    sleep 240
    echo "restarting loop"
  fi
  sleep 30
done
