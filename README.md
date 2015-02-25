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

The script outputs a pair of *bed.gz* and *bed.gz.tbi* files. Both files have to be available by URL in a webserver and the link to the *bed.gz* file should be provided

### Dependecies

 1. `bedSort` from the [UCSC tools](http://hgdownload.cse.ucsc.edu/admin/exe/)
 2. `bgzip` and `tabidx` from [samtools](http://samtools.sourceforge.net/tabix.shtml).

### Further analyses

Check out the [NG2B](https://github.com/mscastillo/NG2B/blob/master/NG2B.md#how-to-visualize-long-range-chromosomal-interactions) to find how to visualise the resulting files.


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


# `HistoneMap/` [:octocat:](https://github.com/mscastillo/ChIP-Seq/tree/master/HistoneMap)

Suite of *MATLAB* scripts for plotting heatmaps from histones (or any other ChIP-Seq) experiments around a set of genomic regions.

### Inputs

1. All the scripts work in batch for a given set of input experiments. Once run, the script will ask you to select multiple *matrix* files. The input format of these *matrix* files should match with the output format of `bw2histogram.sh` [:octocat:](https://github.com/mscastillo/ChIP-Seq/blob/master/bw2histogram.sh), that uses Homer's `annotatePeaks.pl` to create a histogram around a given set of genomic regions.

2. *peaksfile*, a peak file with the genomic regions that was considered to generate the *matrix* input files. This file is important to reshape the histograms profiles with different number of rows. The *peaksfile* should be in bed format including an extra fourth column with the number of reads falling on each peak (this information can be taken from the original *bigwig* file by using `bigWigToWig`).

3. Additional inputs files may be required depending of the desired normalization, sorting, etc...

 #### [`heatmaps_sorted_by_peaks.m`](https://github.com/mscastillo/ChIP-Seq/blob/master/HistoneMap/heatmaps_sorted_by_peaks.m)

 This script do not requires any additional file. It will simply resort all the histograms according to the number of counts falling in any genomic regions (peaks).

 #### [`heatmaps_sorted_by_histones_fold_change.m`](https://github.com/mscastillo/ChIP-Seq/blob/master/HistoneMap/heatmaps_sorted_by_histones_fold_change.m)

 This script will resort all the histograms according to the fold change at each genomic regions (peaks). It will requires two addtional input files in *matrix* format, it will compute the cumulative fold change for each of the genomic regions and it will sort all the histograms in descencing order according to these fold changes.

### Outputs

The script will generate and save as a high-resolution PDF a heatmap for each *matrix* input file and an extra figure with the peaks profile.

All the heatmaps are normalised to make them directly comparable. Use the parameters *saturation_peak_cutoff* and *saturation_histones_cutoff* to control the saturation thresholds. The plots will use the colormaps defined on the top of the script, from black to *color1* and black to *color2*.

### Further analyses

You might consider the use of the next commad to stack all the PDFs toghether in a single one (it requires to install `imagemagix`):

```bash
montage -tile 7x1 -geometry 1000 -density 500 *counts.pdf *heatmap.pdf *sorted*.pdf montage.pdf
```
