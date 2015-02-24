ChIP-Seq
========

This repository includes scripts for processing and analysing ChIP-Seq data.


# `bed2frip.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bed2frip.sh)
Script to compute the Fraction of Reads-in-Peaks (FRiP) of a given peak profile in *bed* format. For adittional information about this quality index, see:

> ChIP-seq guidelines and practices of the ENCODE and modENCODE consortia. *Genome Research* (2012). [PubMed: 22955991](http://www.ncbi.nlm.nih.gov/pubmed/22955991)

### Inputs

This scripts requires both:

1. the peaks file in *bed* format
2. the original *BED* file with aligned reads

The FRiP can be calculated in batch for all experiments from a given directory.

### Outputs

The script will output, for each pair of *BED*-*bed* files, the name of the sample and the FRiP.


# `bed2rf2matrix.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bed2rf2matrix.sh)

Script to map a set of peaks files to the genomic coordinates of an enzyme's restriction fragments. Later, it computes a binary matrix with all the genomic regions in rows, indicating with *one* whether a peak profile (in columns) has a binding event within any of the genomic coordinates or *zero* otherwise.


# `bedpe2washu.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bedpe2washu.sh)

Script to process a long-range interaction data and display it on [WashU epigenome browser](http://epigenomegateway.wustl.edu/browser/) under the long-range interaction data.

### Inputs

An input file with the long-range interactions in [*bedpe* format](http://bedtools.readthedocs.org/en/latest/content/general-usage.html#bedpe-format).

### Outputs

The script outputs a pair of *bed.gz* and *bed.gz.tbi* files with the [format required](http://washugb.blogspot.co.uk/2012/09/prepare-custom-long-range-interaction.html) by WashU epigenome browser.

### Dependecies

 1. `bedSort` from the [UCSC tools](http://hgdownload.cse.ucsc.edu/admin/exe/)
 2. `bgzip` and `tabidx` from [samtools](http://samtools.sourceforge.net/tabix.shtml).

### Further analyses

Check out the [NG2B](https://github.com/mscastillo/NG2B/blob/master/NG2B.md#how-to-visualize-long-range-chromosomal-interactions) to find how to visualise the resulting files. Click [here](https://www.youtube.com/watch?v=im4AUvXFISM) to watch a tutorial on YouTube.


# `bw2histogram.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bw2histogram.sh)

Script to generate a histogram from a given *bigwig* file around specifig genomic regions.

### Inputs

Next files are require to perform this analysis:

1. A *bigWig* file (that will be transform into *bedGraph* format). This script can perform the analysis in batch for all *bigWig* files from a given directory.

2. A *bed* file with the genomic coordinates in [HOMER's peak file format](http://homer.salk.edu/homer/ngs/quantification.html) where to compute the histogram.

Additionally, the script requires to set up the *region* and *bin* sizes as a standard parameter of the histogram and the *genome build*.

### Outputs

The script will generate, for each *bigWig* file, a matrix (in *tsv* format) with the histograms around each genomic coordinates.

### Dependecies

- `bigWigToWig`, from [UCSC tools](http://hgdownload.cse.ucsc.edu/admin/exe/).
- `annotatePeaks.pl` from [Homer](http://homer.salk.edu/homer/ngs/annotation.html).

### Further analyses

You might consider the use of any of the  MATLAB's scripts in [HistoneMap/](https://github.com/mscastillo/ChIP-Seq/tree/master/HistoneMap) to plot the results as a HeatMap.
