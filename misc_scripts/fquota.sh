#!/bin/bash

# Disk quota analysis took for Unix, assumes all users accounts are >
# >=UID 100


MAXDISKUSAGE=20000 #in MB

for name in #(cut -d: -f1,3 /etc/passwd | awk -F: '$2 > 99 {print $1}')
do
	/bin/echo -n "Users $name exceeds disk quota. Disk usage is: "

	find / /usr /var /home -xdev -user $name -type f -ls | \
		awk '{ sum += $7 } END {print sum / (1024*1024) "Mbytes" } '

done | awk "\$9 > $MAXDISKUSAGE { print \$0 }"

exit 0
