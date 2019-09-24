#!/bin/bash
#
# CAMERA DETECTION on WIFI 
#
# This script tries to detect and disconnect potenial hidden cameras based on a well known list of devices' mac addresses , with focus on potential hidden cameras.
#
# Dependencies: GNU/Linux host ; aircrack-ng suite.
# based on dropick by Julian Oliver.
#	github.com/JulianOliver
# STILL IN DEVELOPMENT
#Takes two arguments: wireless card and BSSID (wifi name)


#chech for parameters

if [ $# -ne 2 ] ; then
	echo "USAGE: $0 <WIRELESS CARD> <BSSID OF AP>"
 	exit 0
fi


# Check if airmon-ng is installed in the machine

if ! type airmon-ng > /dev/null ; then
	echo " Airmon-ng missing..."
	echo " Please install it with : sudo apt-get install 

shopt -s nocasematch # Set shell to ignore case
shopt -s extglob # For non-interactive shell.

readonly NIC=$1 # Your wireless NIC
readonly BSSID=$2 # Network BSSID (AirBnB WiFi network)
readonly MAC=$(/sbin/ifconfig | grep $NIC | head -n 1 | awk '{ print $5 }')
# MAC=$(ip link show "$NIC" | awk '/ether/ {print $2}') # If 'ifconfig' not
# present.
readonly GGMAC='@(30:8C:FB*|00:24:E4*)' # Match against DropCam and Withings 
readonly POLL=30 # Check every 30 seconds
readonly LOG=/var/log/dropkick.log

airmon-ng stop mon0 # Pull down any lingering monitor devices
airmon-ng start $NIC # Start a monitor device

while true;
    do  
        for TARGET in $(arp-scan -I $NIC --localnet | grep -o -E \
        '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
           do
               if [[ "$TARGET" == "$GGMAC" ]]
                   then
                       # Audio alert
                       beep -f 1000 -l 500 -n 200 -r 2
                       echo "WiFi camera discovered: "$TARGET >> $LOG
                       aireplay-ng -0 1 -a $BSSID -c $TARGET mon0 
                       echo "De-authed: "$TARGET " from network: " $BSSID >> $LOG
                       echo '
			_________                                  ___________                     __                 
\_   ___ \_____    _____   ________________\__    ___/___________    ____ |  | __ ___________ 
/    \  \/\__  \  /     \_/ __ \_  __ \__  \ |    |  \_  __ \__  \ _/ ___\|  |/ // __ \_  __ \
\     \____/ __ \|  Y Y  \  ___/|  | \// __ \|    |   |  | \// __ \\  \___|    <\  ___/|  | \/
 \______  (____  /__|_|  /\___  >__|  (____  /____|   |__|  (____  /\___  >__|_ \\___  >__|   
        \/     \/      \/     \/           \/                    \/     \/     \/    \/       	   
		       '
	       else
                        echo $TARGET": is not a DropCam or Withings device. Leaving alone.."
               fi
           done
           echo "None found this round."
           sleep $POLL
done
airmon-ng stop mon0

echo "exiting program ...."
