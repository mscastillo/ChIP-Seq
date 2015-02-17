#!/bin/bash
######################################
# 18 Spet 2013
# David Ruau, Department of Haematology
# Gottgens lab
# CIMR, University of Cambridge
# All right reserved.
# Licence: GPL (>=2)
######################################

######################################
# GLOBAL VARIABLES
######################################

# formatting
underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`

usage(){
	echo 
	echo -e "${bold}Utility to add the user submitted bed file to the binary matrix of selected samples${normal}"
	echo 
	echo -e "${bold}NAME${normal}"
	echo '     make_matrix'
	echo 
	echo -e "${bold}SYNOPSIS${normal}"
	echo '     usage: make_matrix [-l, --list list of files] [-t, --temp_folder path] [-m, -md5 md5 file name] [-x, --mapping_genome reference genoeme]'
	echo 
	echo -e "${bold}DESCRIPTION${normal}"
	echo '     This utility will read in the selection made by the user and combine it with the user submitted bed file'
	echo 
	echo '     The options are as follows:'
	echo 
	echo -e "     ${bold}-h, --help${normal}"
	echo '             Show this message'
	echo 
	echo -e "     ${bold}-l, --list ${underline}FILE${nounderline}${normal}"
	echo '             The user peaks/bed file (3 columns or more columns)'
	echo 
	echo -e "     ${bold}-t, --temp_folder ${underline}PATH TO FOLDER${nounderline}${normal}"
	echo '             The temp folder for the processing.'
	echo 
	echo -e "     ${bold}-m, --md5 ${underline}FILE${nounderline}${normal}"
	echo '             The md5 signature for the selection. This is also the file name'
	echo 
	echo -e "     ${bold}-w, --web_folder ${underline}PATH${nounderline}${normal}"
	echo '             The full path to the web folder'
	echo 
	echo -e "     ${bold}-x, --mapping_genome ${underline}REFERENCE GENOME${nounderline}${normal}"
	echo '             The considered genome of reference, i.e. hg19 or mm10'
	echo 
	echo  -e "${bold}AUTHOR${normal}"
	echo '     David Ruau <davidruau@gmail.com>'
	echo '     Department of Haematology, Gottgens lab'
	echo '     CIMR, University of Cambridge'
	echo '     Licence: GPL (>=2)'
	echo
	echo '18 Sept, 2013'
	exit 1
}

FILE_LIST=
TEMP_FOLDER='tmp'
MD5_FILE='dice_heatmap'
CURRENTPATH=$(pwd)
WEB_FOLDER=$(echo $CURRENTPATH"/bed")
MAPPING_GENOME=

# Note that the : after an option flag means that it should have a value instead of
# just being the boolean flag that a is.
# OPTS=`getopt -o hg:m:s:x: --long help,trimmed -- "$@"`
OPTS=`getopt -o hl:t:m:w:x: --long help,list,temp_folder,md5,web_folder,mapping_genome -- "$@"`
if [ $? != 0 ]
	then
	# something went wrong, getopt will put out an error message for us
	exit 1
fi

eval set -- "$OPTS"

while true
do
	case "$1" in
		-h | --help)
			usage
			;;
		# for options with required arguments, an additional shift is required
		-l | list)
			FILE_LIST=$2
			shift 2
			;;
		-t | temp_folder)
			TEMP_FOLDER=$2
			shift 2
			;;
		-m | md5)
			MD5_FILE=$2
			shift 2
			;;
		-w | web_folder)
			WEB_FOLDER=$2
			shift 2
			;;
		-x | mapping_genome)
			MAPPING_GENOME=$2
			shift 2
			;;
		--) break
			;;
		--*) break
			;;
		-?)
			usage
			;;
	esac
done

bedFolder=$WEB_FOLDER"/"

rm -rf $TEMP_FOLDER
mkdir -p $TEMP_FOLDER
cd $TEMP_FOLDER

echo ${FILE_LIST[@]} > file_list

IFS=',' read -ra FILE_ARRAY <<< "$FILE_LIST"

#######################################
# MAKING BIG MATRIX FOR USER SELECTION
#######################################

# prefix path to each array element
FILE_PATH_ARRAY=( "${FILE_ARRAY[@]/#/$bedFolder}" )

# Append extension
FILE_PATH_ARRAY=( "${FILE_PATH_ARRAY[@]/%/.bed}" )

# Concatenate all selected bed files
# the Unix sort is faster than sortBed from bedops
cat ${FILE_PATH_ARRAY[@]} | sort -n -k 1b,1 -k 2,2 > ALL_PEAKS_sorted.bed

# merge overlapping (using bedtools)
"/raid/codex.stemcells.cam.ac.uk/asset/mergeBed" -d -1 -i ALL_PEAKS_sorted.bed > ALL_PEAKS_merged.bed

# format chr coordinates
awk ' {printf $1"_"$2"_"$3}{for(i=4;i<=NF;i++) printf "\t"$i}{printf("\n")} ' ALL_PEAKS_merged.bed | cut -f1 > COORD ;

## ADD HEADER
echo "chr_start_end" | cat - COORD > ALL_PEAKS_COORD

## RUN INTERSECT BED ON EACH INDIVIDUAL FILE AND ALL_PEAKS
for i in $( seq 0 $((${#FILE_ARRAY[@]} - 1)) ) ; do
	
    ## Proposed solution using bedtools-2.18.0
    # https://github.com/arq5x/bedtools2/releases
    # bedtools REQUIRES bed files to be tab separated
    # To transform space to tab use:
    # unexpand ${FILE_PATH_ARRAY[$i]} > bedFileTab    
    # Remove trailing white spaces
    # sed -i 's/[ \t]*$//' ${FILE_PATH_ARRAY[$i]}
    
    "/raid/codex.stemcells.cam.ac.uk/asset/intersectBed" -c -a ALL_PEAKS_merged.bed -b ${FILE_PATH_ARRAY[$i]} | cut -f4 > temp
	
	## NORMALIZE RESULTS from intersectBed. If >1 then = 1
	awk '{if($1>0) $1=1; print $1}' temp > temp2
	
	## ADD HEADER MADE OF BED FILE NAME
	echo ${FILE_ARRAY[$i]} | cat - temp2 > paste_$i
	
done

## APPEND TO FINAL MATRIX
paste ALL_PEAKS_COORD paste_* > ../$MD5_FILE".txt"
cd ..
rm -rf $TEMP_FOLDER

echo
echo "Plotting..."
R CMD BATCH dice_heatmap.r
echo
echo "done!"

