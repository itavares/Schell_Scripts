#!/bin/bash

# Who_is_knocking is a script where is check's for possible ssh connections
# and retrieves the geo-location information from the ip.
# A file called sorted_ip.txt will be created which contains all the ip-addresses that attempted to ssh into the machine
# Dependencies: jq 
# To install jq : sudo apt-get update && sudo apt-get install jq
# By: Ighor Tavares

# STILL IN DEVELOPMENT


cat /var/log/auth.log | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" > ip_list.txt

uniq -u ip_list.txt > sorted_ip.txt
#clear file
rm ip_list.txt

nline=1

cat sorted_ip.txt | while read line
do
	echo "=====$line======"
	curl -s https://ipvigilante.com/$line | jq '.data.city_name, .data.subdivision_1_name, .data.country_name, .data.longitude , .data.latitude'
	echo "================"
	echo " " 
done


