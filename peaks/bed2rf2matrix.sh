#!/bin/bash

## PARAMETERS ##########################################################

   RF_FILE="../digestion_and_promoters/MPromDB.mm9/digestion_without_MPromDB_promoters.bed"
   BED_FILES=($(ls ../peaks.mm9/*.bed))
   SUFFIX=$RANDOM

########################################################################

echo "chr_start_end" > coord.$SUFFIX.txt
cat $RF_FILE | awk '{print $1"_"$2"_"$3}' >> coord.$SUFFIX.txt
echo "chr"$'\t'"start"$'\t'"end" > coord.$SUFFIX.tsv
cat $RF_FILE | awk 'BEGIN{OFS="\t"}{print $1,$2,$3}' >> coord.$SUFFIX.tsv

for k in $( seq 0 $((${#BED_FILES[@]} - 1)) ); do
	
    #
    FILE=$( basename ${BED_FILES[$k]} )
    NAME=${FILE%.*}
    #
    echo " - $NAME"
    #
    intersectBed -a $RF_FILE -b ${BED_FILES[$k]} -c -wa > $NAME.$SUFFIX.intersect
	#
	echo $NAME > $NAME.$SUFFIX.column
	cat $NAME.$SUFFIX.intersect | awk '{if($4>0) $4=1 ; print $4}' >> $NAME.$SUFFIX.column

done

paste coord.$SUFFIX.tsv *.$SUFFIX.column > matrix.tsv
paste coord.$SUFFIX.txt *.$SUFFIX.column > matrix.txt
rm -f *.$SUFFIX.*
