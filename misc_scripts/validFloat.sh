#!/bin/bash

#validfloat-- Test whether a number is a valid floating point value
# nOta that his script cannot accept scientific (1.304e5) nottation



# To test whether an entered value is a valid floating-point number,
# we need to split the value into two parts: the integer portion and the frac portion
# Ww test the first part to see whether its a valid ineger, and then we test whether the seocnd part is a 
# valid >0 integer. So -30.5 is valid but -30.-8 is not.


# to invlude another shell script as part of this one, use the "." source notation.

#calling the function from another script

. validint.sh 


validFloat()
{
	fvalue="$1"

	#check whether the input has a decimal point
	if [ ! -z $(echo $fvalue | sed 's/[^.]//g') ] ; then

		#extract the part before the decmial point
		decimalPart="$(echo $fvalue | cut -d. -f1)"

		#extract fractional digits after the decimal point
		fractionalPart="${fvalue#*\.}"
	
		#start by testing the decimal part, which is everything to the left of the decimal part

		if [ ! -z $decimalPart ] ; then
			# "!" reverses test logic, so the following is 
			# if NOT a valid integer
			if ! validint "$decimalPart" "" "" ; then
				return 1
			fi
		fi

	# Now lets test the fractional value

	# To start, you cant have a negative sign after the decimal point

	if [ "${fractionalPart%${fractionalPart#?}}" = "-" ] ; then
		echo " Invalid floating-point number: '-' not allowed after decimal point" >&2
		return 1
	fi

	if [ "$fractionalValue" != "" ] ; then
		# if the fractional part is not a valid integer
		if ! validint "$fractionalPart" "0" "" ; then
			return 1
		fi
	fi

else

	#if the entire value is just "-" , that's not good either
	if [ "$fvalue" = "-" ] ; then
		echo " Invalid floating-point format." >&2
		return 1
	fi


	#finally check that the ramining difgits are actually valid integers

	if ! validint "$fvalue" "" "" ; then
		return 1
	fi
fi

return 0 
		

}


if validFloat $1; then
	echo "$1 Is a valid floating-point number"
fi
exit 0


