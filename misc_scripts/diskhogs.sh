#!/bin/bash

#Disk quota analysis tool for Unix. Assumes all users are >=100.
#Emails a message to each violating user and reports a summary to the screen



MAXDISKUSAGE=500 #in MB
violators="/tmp/diskhogs0$$"

trap "$(which rm) -f $violators" 0

for name in #(cut -d: -f1,3 /etc/passwd | awk -F: '$2 > 99 { print $1 }')
do
/bin/echo -n "Users $name exceeds disk quota. Disk usage is: "

	find / /usr /var /home -xdev -user $name -type f -ls | \
		awk '{ sum += $7 } END {print sum / (1024*1024) "Mbytes" } '

done | awk "\$9 > $MAXDISKUSAGE { print \$0 }" > $violators

if [ ! -s $violators ] ; then
	echo "No users exceed the disk quota of ${MAXDISKUSAGE}MB"
	cat $violators
	exit 0
fi


while read account usage ; do
	cat << EOF | fmt | mail -s " Warning: $account Exceed Quota" $account Your disk usage is $(usage)MB, but you have been allocated only ${MAXDISKUSAGE}MB. This means that you need to delete some of your files, compress you files (see 'gzip' for powerful and etc..), or talk with us about increasing your disk allocation.

Thanks for your cooperation in this matter

Your Friendly admin
EOF

echo " Account $account has $usage MB of disk use. User notified"

done < $violators

exit 0

