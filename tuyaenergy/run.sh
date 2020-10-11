#!/bin/bash
#set -e

CONFIG_PATH=/data/options.json

MQTTSERVER=$(jq --raw-output ".mqttserver" $CONFIG_PATH)
MQTTPORT=$(jq --raw-output ".mqttport" $CONFIG_PATH)
MQTTUSER=$(jq --raw-output ".mqttuser" $CONFIG_PATH)
MQTTPASSWORD=$(jq --raw-output ".mqttpassword" $CONFIG_PATH)
MQTTTOPIC=$(jq --raw-output ".mqtttopic" $CONFIG_PATH)

echo "Parameters: $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTTOPIC $MQTTPORT"

while true; do
  python tuyaConsuption.py $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTTOPIC $MQTTPORT || true
  sleep 60
done
