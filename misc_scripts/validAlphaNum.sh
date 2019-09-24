#!/bin/bash

#Ensures that input consists only of alphabetical and numberic chars


validAlphaNum()
{
	#Validate arg: returns 0 if all upper+lower+digits ; 1 otherwise

	#remove all unacceptable chars.
	validchars="$(echo $1 | sed -e 's/[^[:alnum:]]//g')"

	if [ "$validchars" = "$1" ] ; then
		return 0 
	else
		return 1
	fi
}

# BEGIN MAIN SCRIPT-- DELETE OR COMMENT OUT EVERYTHING BELOW THIS LINE 
# IF YOU WANT TO INCLUDE THIS IN OTHER SCRIPTS

/bin/echo -n "Enter input: "

read input
#input validation

if ! validAlphaNum "$input" ; then
	echo " Please enter only letters and numbers." >&2
	exit 1
else
	echo "input is valid"
fi

#check for parameters

#if [ "$#" -ne 1 ] ; then
#	echo " USAGE: $0 <input> " >&2
#       exit 1
#fi       


exit 0
