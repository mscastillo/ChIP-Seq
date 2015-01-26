ChIP-Seq
========

This repository includes scripts for processing and analysing ChIP-Seq data.


# `frip.sh.m` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/frip.sh)

This script will compute the Fraction of Reads-in-Peaks (FRiP) for all the peaks file in the current folder.

> ChIP-seq guidelines and practices of the ENCODE and modENCODE consortia. *Genome Research* (2012). [PubMed: 22955991](http://www.ncbi.nlm.nih.gov/pubmed/22955991)

It requires to be have the original file with the aligned reads, in *BED* format, into the same folder.


# `bed2rf2matrix.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bed2rf2matrix.sh)

Script to map a set of peaks files to the genomic coordinates of an enzyme's restriction fragments. Later, it computes a binary matrix with all the genomic regions in rows, indicating with *one* whether a peak profile (in columns) has a binding event within any of the genomic coordinates or *zero* otherwise.


# `bedpe2washu.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bedpe2washu.sh)

This script process a file in *bedpe* format and produce a pair of *bed.gz* and *bed.gz.tbi* files to display the data on [WashU epigenome browser](http://epigenomegateway.wustl.edu/browser/) under the long-range interaction data.

This script depends on `bedSort` (from the [UCSC tools](http://hgdownload.cse.ucsc.edu/admin/exe/)) and `bgzip` and `tabidx` from [samtools](http://samtools.sourceforge.net/tabix.shtml).
