#!/bin/bash

## ABOUT # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# This script uses the annotation tool from HOMER to generate a histogram from a ChIP-Seq experiments.
# It will uses the BED and a bigwig files from a histone experiment to generate a matrix with the number of counts around the regions defined in a given peaks file.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

## VARIABLES # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

   PEAKS_FILE='example/peaks.homer.bed' # A file with the genomic coordinates to where it is desired to compute the histogram. Minimun five columns (additional details, http://homer.salk.edu/homer/ngs/quantification.html).
   GENOME='mm10' # Genome considered for the alignment. Possible values: 'hg19', 'mm10', etc...
   
## PARAMETERS # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   bw_FILES=($(ls *.bw)) # Will perform the analysis on all the bw files of current folder.
   REGION_SIZE=2000 # Region arround the peak centre (in bp) where to perform the analysis.
   BIN_SIZE=10 # Size of the bin (in bp) to perform the analysis.
   PATH=$PATH:/home/Programs/HOMER/bin/:/home/Programs/UCSC_programs/ # Update the PATH with the dependencies as necessary.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

for k in $( seq 0 $((${#bw_FILES[@]} - 1)) ) ; do

   FILE=${bw_FILES[$k]}
   NAME=${FILE%.*}
   OUTPUTFILE=$NAME".matrix"
   bigWigToWig $NAME.bw $NAME.bedGraph
   annotatePeaks.pl $PEAKS_FILE $GENOME -size $REGION_SIZE -hist $BIN_SIZE -bedGraph $NAME.bedGraph -pcount -ghist -strand both -noadj > $OUTPUTFILE
   rm -f $NAME.bedGraph
   
done
