#!/bin/bash

if [ $# != 1 ]; then
	echo "Invalid arguments, exiting."
	exit 2
fi

# store default so printing duplicates later is avoided
DEFAULTPATH=`which $1 2>/dev/null`

# if first two characters of the 'which' are no,
# then there is no default path for the command
if [ `echo $DEFAULTPATH | cut -c1-2` == "no" ]; then
	echo "No default path for command."
else
	echo "The current path to the command $1:"
	echo "$DEFAULTPATH"
fi

echo ""
echo "Other versions of the command $1 are:"

# variable to keep track of whether any other paths have been found
found=false

cd /
for i in `ls -d */`
do	
	cd $i 2>/dev/null
	CURRDIR=$(pwd)
	# if the output from find isn't blank, then we have found a path
	if [[ `find -maxdepth 3 -name $1 2>/dev/null` != "" ]]; then
		found=true
	fi
	# run find, convert to absolute path, 
	# remove duplicate path and clean resulting blank line
	find -maxdepth 3 -name $1 2>/dev/null | sed -e 's,\.,'$CURRDIR',g' \
	| sed "s+$DEFAULTPATH++g" | sed '/^$/d'
	cd ..	
done

if [ $found == false ]; then
	echo "No other version of the command $1 is found."
fi


