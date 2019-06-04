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
    #python vodafone.py
    URL=$(curl -Ls -w %{url_effective} http://google.com)
    URL=${URL:0:47}login${URL:53:165}
    echo "$URL"
    DATA=chooseCountry=VF_IT%2F&userFake=${USERNAME}&UserName=VF_IT%2F${USERNAME}&Password=${PASSWORD}&rememberMe=true&_rememberMe=on
    curl --data "${DATA}" ${URL}
  fi
  sleep 30
done
