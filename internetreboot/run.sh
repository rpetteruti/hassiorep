#!/bin/bash
#set -e

CONFIG_PATH=/data/options.json

TUYAPLUGIP=$(jq --raw-output ".tuyaplugip" $CONFIG_PATH)

echo "Parameters: $TUYAPLUGIP "

#echo "nameserver ${DNS}" > /etc/resolv.conf
echo "Wait 1200 secs before start loop"
sleep 1200
echo "starting loop"
while true; do
  if ping -c 10 www.google.it &> /dev/null
  then
    echo "$(date) Internet OK"
  else
    echo "$(date) Internet KO, starting REBOOT the modem and wait 5 minutes"
    curl "http://$TUYAPLUGIP/cm?cmnd=Backlog%20Power%20OFF%3BDelay%20600%3BPower%20ON"
    
    #curl "http://$TUYAPLUGIP/cm?cmnd=Power%20Off"
    #sleep 60
    #curl "http://$TUYAPLUGIP/cm?cmnd=Power%20On"
    
    echo "Wait 300 + 600 secs before checking again"
    sleep 300
    echo "restarting loop"
  fi
  sleep 600
done
