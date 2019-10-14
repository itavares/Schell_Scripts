#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "USAGE: $0 <domain.txt>" >&2
	exit 0
fi


sub_domains=$1 #pass as .txt file
for site in $(cat $sub_domains) 
do
	curl -s -o /dev/null -I -w "%{http_code}" https://$site --max-time 5;
	printf " - $site \n"
done > alive.txt
