#!/bin/bash
#Validint - validates integers and also negative integers

validint()
{
	#validate first field and test that value against min value $2 and/or max
	#value $3 if they are suplied . If the value isn't within range, or it's not 
	#composed  of digits, fail

	number="$1";	min="$2";	max="$3";

	if [ -z $number ] ; then
		echo " You didn't enter anything. Please enter a number." >&2
		return 1
	fi

	#is the first character a '-' sign?

	if [ "${number%${number#?}}" = "-" ] ; then
		testvalue="${number#?}" 		#grab all bu the first character to test.
	else
		testvalue="$number"
	fi

	#creates a version of the number that has no digits for testing
	nodigits="$(echo $testvalue | sed 's/[[:digit:]]//g')"

	#check for nondigit characters
	if [ ! -z $nodigits ] ; then
		echo " Invalid number format! Only digits, no commas, spaces, etc" >&2
		return 1
	fi

	if [ ! -z $min ] ; then
		# IS the input less than the minimum value?
		if [ "$number" -lt "$min" ] ; then
			echo " Your value is too small : smallest acceptable value is $min." >&2
			return 1
		fi
	fi

	if [ ! -z $max ] ; then
		#is the input more than the maximum value?
		if [ "$number" -gt "$max" ] ; then
			echo " Your value is too big: largest acceptable value is $max." >&2
			return 1
		fi
	fi


return 0

}

# IF YOU WANT TO USE THIS FUCKING INTO ANOTHER SCRIPT COPY FROM THIS LINE ABOVE ^ 
#SCRIPT CALL ==================
#Input validadtion

#if validint "$1" "$2" "$3" ; then
#	echo " Input is a valid integer within your constraints."
#fi

