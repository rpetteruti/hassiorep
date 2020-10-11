#!/usr/bin/python
#
# Power Probe - Wattage of smartplugs
import tuyapower
import paho.mqtt.client as mqtt

from time import sleep
import datetime
import os
import sys

#python tuyaConsuption.py $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTTOPIC $TUYAIPS $TUYADEVICEID
# MQTT server - EDIT THIS
MQTTSERVER=sys.argv[1]
MQTTUSER=sys.argv[2]
MQTTPASSWORD=sys.argv[3]
MQTTPORT=sys.argv[4]
MQTTTOPIC=sys.argv[5]

##########

#devices = tuyapower.deviceScan()

tuyaips = sys.argv[6].split(",")
tuyadevids = sys.argv[7].split(",")
tuyadevkeys = sys.argv[8].split(",")
tuyadevvers = sys.argv[9].split(",")
iteration = 0
for ip in tuyaips:
    
    ip = tuyaips[iteration]
    id = tuyadevids[iteration]
    key = tuyadevkeys[iteration]
    vers = tuyadevvers[iteration]
    (on, w, mA, V, err) = tuyapower.deviceInfo(id, ip, key, vers)
    print("Device at %s: ID %s, state=%s, W=%s, mA=%s, V=%s [%s]"%(ip,id,on,w,mA,V,err))
    mqttc = mqtt.Client(MQTTUSER)
    mqttc.username_pw_set(MQTTUSER, MQTTPASSWORD)
    mqttc.connect(MQTTSERVER, MQTTPORT)


    payload = '{ "power": '+str(w)+', "current": '+str(mA)+', "voltage": '+str(V)+' }'
    configPayploadPower = '{"name": "tuya_'+id+'_power", "state_topic": "'+MQTTTOPIC+id+'/state", "unit_of_measurement": "W", "value_template": "{{ value_json.power}}" }'
    configPayploadCurrent = '{"name": "tuya_'+id+'_current", "state_topic": "'+MQTTTOPIC+id+'/state", "unit_of_measurement": "mA", "value_template": "{{ value_json.current}}" }'
    configPayploadVoltage = '{"name": "tuya_'+id+'_voltage", "state_topic": "'+MQTTTOPIC+id+'/state", "unit_of_measurement": "V", "value_template": "{{ value_json.voltage}}" }'

    mqttc.publish("homeassistant/sensor/tuya_"+id+"/power/config", configPayploadPower,retain=False)
    mqttc.publish("homeassistant/sensor/tuya_"+id+"/current/config", configPayploadCurrent,retain=False)
    mqttc.publish("homeassistant/sensor/tuya_"+id+"/voltage/config", configPayploadVoltage,retain=False)
    mqttc.publish(MQTTTOPIC+id+"/state",payload ,retain=False)
    mqttc.loop(2)

    iteration = iteration + 1
