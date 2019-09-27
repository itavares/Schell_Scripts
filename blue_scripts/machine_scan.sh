#!/bin/bash

# This script is designed to scan and gather information about the system.
# Must run as SUDO.

#List:
#	-System infoi
#	-users in the machine
#	-Last logins
#	- 
#	-users bash_history
#	-
#
#
#
#
#

rm report.txt 2>/dev/null

deli="=========="

if [ "$EUID" -ne 0 ] ; then
	echo "****************"
	echo "Must run as SUDO";
	echo "****************";
	exit 0;
fi

#create report
touch report.txt

#system info
echo $deli"OS INFO"$deli >> report.txt
lsb_release -a >> report.txt 2>>/dev/null
echo "----------" >> report.txt
uname -a >> report.txt



#users in the machine

echo " " >> report.txt
echo $deli"USERS"$deli >> report.txt
getent passwd | grep "/home/" | cut -d ":" -f 1,3 >> report.txt



#users=getent passwd | grep "/home/" | cut -d ":" -f 1 | grep -v "syslog"
how_many= getent passwd | grep "/home/" | cut -d ":" -f 1 | wc -l


# users bash history
mkdir user_bash_history 2>>/dev/null

for i in $(getent passwd | grep "/home/" | cut -d ":" -f 1 ) ; do 
	echo  "Getting Bash History of : $i"

	cat  -s	/home/$i/.bash_history >  user_bash_history/$i"_bash_history"  2>/dev/null
	sleep 1
done

echo "done"
echo " "


# last logins | IP Info
echo "Getting last users to have logged in..."
echo " " >> report.txt
echo "______Last Logons_____" >> report.txt
last -a >> report.txt
echo " " >> report.txt
echo "______IP LOCATION_____" >> report.txt

loading="#"
increment="#"
for i in $(last -a | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | sort -u | uniq -u) ; do
	echo "*****$i*****" >> report.txt
	curl -s https://ipvigilante.com/$i | jq '.data.city_name, .data.subdivision_1_name, .data.country_name' >> report.txt
	echo -ne "$increment"
	increment=$increment$loading	
done
sleep 1
echo " "
echo "done"
#...


 
