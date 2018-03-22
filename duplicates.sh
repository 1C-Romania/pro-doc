#!/bin/bash

INPUT="fileName.rst"
DIR="./dup"
mkdir -p $DIR
LINKSF="${DIR}/links.txt"

grep -E "\.\. \|\S.*\|" $INPUT | grep -oE "\|\S.*\|" | sort | uniq -d > $LINKSF

while read OLD; do
    NEW="|`gdate +%s%6N`|"
    #Workaround for first match only
    LN=`gsed -n /"$OLD"/= $INPUT | head -1`
    gsed -i ${LN}s/"$OLD"/"$NEW"/ $INPUT
    LN=`gsed -n /\.\.\ "$OLD"/= $INPUT | head -1`
    gsed -i ${LN}s/\.\.\ "$OLD"/\.\.\ "$NEW"/ $INPUT
    grep "$OLD" $INPUT
done < $LINKSF
