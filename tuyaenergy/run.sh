#!/bin/bash
#set -e

CONFIG_PATH=/data/options.json

MQTTSERVER=$(jq --raw-output ".mqttserver" $CONFIG_PATH)
MQTTPORT=$(jq --raw-output ".mqttport" $CONFIG_PATH)
MQTTUSER=$(jq --raw-output ".mqttuser" $CONFIG_PATH)
MQTTPASSWORD=$(jq --raw-output ".mqttpassword" $CONFIG_PATH)
MQTTTOPIC=$(jq --raw-output ".mqtttopic" $CONFIG_PATH)
TUYAIPS=$(jq --raw-output ".tuyaips" $CONFIG_PATH)
TUYADEVICEID=$(jq --raw-output ".tuyadeviceid" $CONFIG_PATH)


echo "Parameters: $MQTTSERVER $MQTTSERVER $MQTTPASSWORD $MQTTTOPIC $TUYAIPS $TUYADEVICEID $MQTTPORT"

while true; do
  python tuyaConsuption.py $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTTOPIC $TUYAIPS $TUYADEVICEID $MQTTPORT || true
  sleep 30
done
