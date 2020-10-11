#!/bin/bash
#set -e

CONFIG_PATH=/data/options.json

MQTTSERVER=$(jq --raw-output ".mqttserver" $CONFIG_PATH)
MQTTPORT=$(jq --raw-output ".mqttport" $CONFIG_PATH)
MQTTUSER=$(jq --raw-output ".mqttuser" $CONFIG_PATH)
MQTTPASSWORD=$(jq --raw-output ".mqttpassword" $CONFIG_PATH)
MQTTTOPIC=$(jq --raw-output ".mqtttopic" $CONFIG_PATH)
TUYADEVIPS=$(jq --raw-output ".tuyadevips" $CONFIG_PATH)
TUYADEVIDS=$(jq --raw-output ".tuyadevids" $CONFIG_PATH)
TUYADEVKEYS=$(jq --raw-output ".tuyadevkeys" $CONFIG_PATH)
TUYADEVVERS=$(jq --raw-output ".tuyadevvers" $CONFIG_PATH)

echo "Parameters: $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTPORT $MQTTTOPIC $TUYADEVIPS $TUYADEVIDS $TUYADEVKEYS $TUYADEVVERS"

while true; do
  python tuyaConsuption.py $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTPORT $MQTTTOPIC $TUYADEVIPS $TUYADEVIDS $TUYADEVKEYS $TUYADEVVERS || true
  sleep 60
done
