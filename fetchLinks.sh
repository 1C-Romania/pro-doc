#!/bin/bash

DIR="./sep/"
INPUT="fileName.rst"

for FILE in ${DIR}*; do
	echo $FILE
	for LINK in `grep -oE "\|\S.*?\|" $FILE`; do
		echo $LINK
		grep -A 2 "\.\. $LINK" $INPUT >> $FILE
	done
done
