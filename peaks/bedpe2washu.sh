#!/bin/bash

# PARAMETERS # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  INPUT="result"
  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

OUTPUT="washu_${INPUT%.*}.bed"
rm -rf $OUTPUT
COUNTER=0
LINE=''
SCORE1=1
SCORE2=2

while read LINE ; do

    CHR1=$( echo $LINE | awk '{print $1}' )
    START1=$( echo $LINE | awk '{print $2}' )
    END1=$( echo $LINE | awk '{print $3}' )
    CHR2=$( echo $LINE | awk '{print $4}' )
    START2=$( echo $LINE | awk '{print $5}' )
    END2=$( echo $LINE | awk '{print $6}' )

    COUNTER=$(($COUNTER + 1))
    echo "chr"$CHR1$'\t'$START1$'\t'$END1$'\t'"chr"$CHR2":"$START2"-"$END2","$SCORE2$'\t'$COUNTER$'\t'"."  >> $OUTPUT
    COUNTER=$(($COUNTER + 1))
    echo "chr"$CHR2$'\t'$START2$'\t'$END2$'\t'"chr"$CHR1":"$START1"-"$END1","$SCORE1$'\t'$COUNTER$'\t'"."  >> $OUTPUT

done < $INPUT

bedSort $OUTPUT "washu_${INPUT%.*}.sorted.bed"
bgzip "washu_${INPUT%.*}.sorted.bed"
tabix -p bed "washu_${INPUT%.*}.sorted.bed.gz"
