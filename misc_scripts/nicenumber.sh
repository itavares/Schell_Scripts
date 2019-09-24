#!/bin/bash

#Nice number --  give a number, shows it in coma sperated form. Expects DD (decimal point delimeter)
#and TD (thousands delimiter) to be instantiated
#	Instantiates nicenum or if a second arg is specified, the output is echoed to stdout


nicenumber()
{
	#NOTE: we assume that '.' is the decimal sperator in the INPUT value
	#to this script, The decimal separator in the output value is '.', unless 
	#specified by the user with the -d flag
	
	separator="$(echo $1 | sed 's/[[:digit:]]//g')"

#	if [ ! -z "$separator" -a "$separator" != "$DD" ] ; then
#	       echo "$0 : unkown decimal separator $separator encountered." >&2
#	       exit 0
#	fi	

	

	integer=$(echo $1 | cut -d. -f1) #left of the decimal
	decimal=$(echo $1 | cut -d. -f2) #right of the decimal
	
#	integer=$(echo $1 | cut "-d$DD" -f1) #left of the decimal
#	decimal=$(echo $1 | cut "-d$DD" -f2) #right of the decimal
	#check if  number has more tha  the integer part
	if [ "$decimal" != "$1"	] ; then
		#there's a fractional part, let's included
		result="${DD:="."}$decimal"
	fi

	thousands=$integer

	while [ $thousands -gt 999 ] ; do
		remainder=$(($thousands % 1000)) #three least sig digitis

		#we need 'remainder' to be three digits. Do we need to add zero?
		while [ ${#remainder} -lt 3 ] ; do #force leading zero
		       remainder="0$remainder"
	       done

	       result="${TD:=","}${remainder}${result}" 	#Builds right to left
	       thousands=$(($thousands / 1000))  #to left of remainder if any
       done

nicenum="${thousands}${result}"
if [ ! -z $2 ] ; then
       echo $nicenum
fi



}



#BEGIN MAIN SCRIPT
#====================

#this is the options for the script  like "-d -f etc..."
while getopts "d:t" opt; do
	case $opt in
		d ) DD="$OPTARG"	;;
		t ) TD="$OPTARG"	;;
	esac
done

shift $(($OPTIND - 1))

#input validation

if [ $# -eq 0 ] ; then
	echo "USAGE: $(basename $0) [-d c] [-t c] number"
	echo " -d specifies the decimal point delimter"
	echo " -t specified the thousands delimeter"
	exit 0
fi

nicenumber $1 1 	#second arg forces nicenumber to "echo" output

exit 0





