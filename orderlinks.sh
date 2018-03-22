#!/bin/bash

INPUT="fileName.rst"
COPY="fileName-copy.rst"
TEMP="fileName-copy-temp.rst"

cp $INPUT $COPY
cp $COPY $TEMP

grep -oE '\|\S.*\|' $INPUT | sort | uniq > links.txt

while read L; do

   echo "$L"
   NEW="|image`gdate +%s%9N`|"
   echo $NEW
   gsed s/"$L"/$NEW/ $TEMP > $COPY
   cp $COPY $TEMP

done < links.txt

grep -oE '\|\S.*\|' $COPY
