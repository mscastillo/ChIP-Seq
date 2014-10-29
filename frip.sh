#!/bin/bash

FILES=($(ls *400bp.bed))
BED_FILE=$(ls *.BED)

for k in $( seq 0 $((${#FILES[@]} - 1)) ) ; do

 FILE=${FILES[$k]}
 NAME="${FILE%.*}"

 if [[ -f $BED_FILE && -f $NAME.bed ]] ; then

 intersectBed -a $NAME.bed -b $BED_FILE -wa > $NAME.intersect
 mergeBed -i $NAME.intersect -n > $NAME.counts
 READS=$(cat $NAME.intersect | wc -l )
 RiP=$(cat $NAME.counts | wc -l )
 FRiP=$( bc -l <<< " scale=2 ; 100*$PEAKS/$RiP  " )
 echo $NAME$'\t'$FRiP
 
 rm -f $NAME.intersect
 rm -f $NAME.counts
 
 fi

done
