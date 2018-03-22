#!/bin/bash

DIR="./sep/"
mkdir $DIR
OUTPUT=${DIR}/head.rst
INPUT="fileName.rst"

N=1

while read LINE; do
	if grep -q -E ^=+$ <<< "$LINE"; then
		echo "$PREV_LINE"
		FILE_NAME=`sed 's/ /_/g' <<< "$PREV_LINE"`
		FILE_NAME=`sed 's/ț/t/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/ţ/t/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/Ț/T/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/ă/a/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/Ă/A/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/â/a/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/Â/A/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/î/i/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/Î/I/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/ș/s/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/ş/s/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/Ș/S/g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/[^_A-Za-z0-9]//g' <<< $FILE_NAME`
		FILE_NAME=`sed 's/__/_/g' <<< $FILE_NAME`
		printf -v NUMBER "%02d" $N
		((N++))
		FILE_NAME=$NUMBER${FILE_NAME}.rst
		echo $FILE_NAME

		OUTPUT=$DIR$FILE_NAME
	fi

	echo "$PREV_LINE" >> $OUTPUT

	PREV_LINE="$LINE"
done < $INPUT
