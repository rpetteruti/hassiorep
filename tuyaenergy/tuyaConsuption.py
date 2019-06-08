#!/usr/bin/python
#
# Power Probe - Wattage of smartplugs - JSON Output
import paho.mqtt.client as mqtt
import pytuya
from time import sleep
import datetime
import os
import sys

LOCALKEY="dummy" #is used only for control the switch in order to read the consumption you can leave as it is

#python tuyaConsuption.py $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTTOPIC $TUYAIPS $TUYADEVICEID
# MQTT server - EDIT THIS
MQTTSERVER=sys.argv[1]
MQTTUSER=sys.argv[2]
MQTTPASSWORD=sys.argv[3]
MQTTTOPIC=sys.argv[4]

# how my times to try to probe plug before giving up
RETRY=2

def deviceInfo( deviceid, ip ,localkey):
    watchdog = 0
    while True:
        try:
            d = pytuya.OutletDevice(deviceid, ip, localkey)
            data = d.status()
            if(d):
                print('Dictionary %r' % data)
                print('Switch On: %r' % data['dps']['1'])
                if '5' in data['dps'].keys():

                    #print('Power (W): %f' % (float(data['dps']['5'])/10.0))
                    #print('Current (mA): %f' % float(data['dps']['4']))
                    #print('Voltage (V): %f' % (float(data['dps']['6'])/10.0))

                    mqttc = mqtt.Client(MQTTUSER)
                    mqttc.username_pw_set(MQTTUSER, MQTTPASSWORD)
                    mqttc.connect(MQTTSERVER, sys.argv[7])

                    powerValue = str(float(data['dps']['5'])/10.0)
                    currentValue = str(data['dps']['4'])
                    voltageValue = str(float(data['dps']['6'])/10.0)

                    payload = '{ "power": '+powerValue+', "current": '+currentValue+', "voltage": '+voltageValue+' }'
                    configPayploadPower = '{"name": "tuya_'+deviceid+'", "state_topic": "'+MQTTTOPIC+deviceid+'/state", "unit_of_measurement": "W", "value_template": "{{ value_json.power}}" }'
                    configPayploadCurrent = '{"name": "tuya_'+deviceid+'", "state_topic": "'+MQTTTOPIC+deviceid+'/state", "unit_of_measurement": "mA", "value_template": "{{ value_json.current}}" }'
                    configPayploadVoltage = '{"name": "tuya_'+deviceid+'", "state_topic": "'+MQTTTOPIC+deviceid+'/state", "unit_of_measurement": "V", "value_template": "{{ value_json.voltage}}" }'

                    mqttc.publish("homeassistant/sensor/tuya_"+deviceid+"/power/config", configPayploadPower,retain=False)
                    mqttc.publish("homeassistant/sensor/tuya_"+deviceid+"/current/config", configPayploadCurrent,retain=False)
                    mqttc.publish("homeassistant/sensor/tuya_"+deviceid+"/voltage/config", configPayploadVoltage,retain=False)

                    mqttc.publish(MQTTTOPIC+deviceid+"/state",payload ,retain=False)


                    mqttc.loop(2)
                    return(float(data['dps']['5'])/10.0)
                else:
                    return(0.0)
            else:
                return(0.0)
            break
        except Exception as e:
            watchdog+=1
            exc_type, exc_obj, exc_tb = sys.exc_info()
            fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
            print(exc_type, fname, exc_tb.tb_lineno)
            if(watchdog>RETRY):
                print("ERROR: No response from plug %s [%s]." % (deviceid,ip))
                return(0.0)
            sleep(2)

#print("Polling Device %s at %s" % (DEVICEID,DEVICEIP))
#python tuyaConsuption.py $MQTTSERVER $MQTTUSER $MQTTPASSWORD $MQTTTOPIC $TUYAIPS $TUYADEVICEID
tuyaips = sys.argv[5].split(",")
tuyadevids = sys.argv[6].split(",")
iteration = 0
for ip in tuyaips:
    print "Gettin power for: "+ip+ " " +tuyadevids[iteration]
    deviceInfo(tuyadevids[iteration],ip,LOCALKEY)
    iteration = iteration + 1
