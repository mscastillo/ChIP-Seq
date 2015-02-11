ChIP-Seq
========

This repository includes scripts for processing and analysing ChIP-Seq data.


# `bed2frip.sh.m` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bed2frip.sh)


This script will compute the Fraction of Reads-in-Peaks (FRiP) of a given peak profile in *bed* format. For adittional information about see:

> ChIP-seq guidelines and practices of the ENCODE and modENCODE consortia. *Genome Research* (2012). [PubMed: 22955991](http://www.ncbi.nlm.nih.gov/pubmed/22955991)

This scripts requires both (*i*) the peaks file in *bed* format and (*ii*) the original *BED* file with aligned reads.


# `bed2rf2matrix.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bed2rf2matrix.sh)


Script to map a set of peaks files to the genomic coordinates of an enzyme's restriction fragments. Later, it computes a binary matrix with all the genomic regions in rows, indicating with *one* whether a peak profile (in columns) has a binding event within any of the genomic coordinates or *zero* otherwise.


# `bedpe2washu.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bedpe2washu.sh)


Script to process a long-range interaction data in *bedpe* format that outputs a pair of *bed.gz* and *bed.gz.tbi* files to display the data on [WashU epigenome browser](http://epigenomegateway.wustl.edu/browser/) under the long-range interaction data.

This script depends on `bedSort` (from the [UCSC tools](http://hgdownload.cse.ucsc.edu/admin/exe/)) and `bgzip` and `tabidx` from [samtools](http://samtools.sourceforge.net/tabix.shtml).


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

* `bigWigToWig`, from [UCSC tools](http://hgdownload.cse.ucsc.edu/admin/exe/).
* `annotatePeaks.pl` from [Homer](http://homer.salk.edu/homer/ngs/annotation.html).

### Further analysis
