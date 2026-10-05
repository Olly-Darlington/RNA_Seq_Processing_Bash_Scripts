#!/bin/bash
# Check shebang with which bash

# Load STAR
module load star/2.7.11b-conda

#varibles
workdir=$(pwd)
rawdir=${workdir}/rawdata
trimdir=${workdir}/trimdata
mkdir ${workdir}/star
stardir=${workdir}/star
genomedir= **Output DIR from format or location of downloaded formatted genome**

# Same loop to pick file name
for f in ${workdir}/rawdata/*_1.fastq.gz
do
R1=$(basename $f | cut -f1 -d.)
# assigns basename variable as the first word in the file name before a '.' 
base=$(echo $R1 | sed 's/_1//')

# Module options for run
STAR   --outMultimapperOrder Random \ # Tells star to output multiple alignments for each read in a random order and randomizes the choice of the primary alignment among the highest-scoring alignments.
       --outSAMmultNmax 1 \ # controls the maximum number of multiple alignments (SAM lines) per read that will be written to the final output BAM file, set to 1
       --runThreadN 8 \ #No of threads, can vary dependant on cpu
       --runMode alignReads \ # Tells star its aligning reads
       --outSAMtype BAM Unsorted \ # Specifies the type of output file, BAM/SAM normally, BAM in this case
       --quantMode GeneCounts \ # Requests specific quantification outputs during read mapping, want genecounts to continue with DEG analysis
       --readFilesCommand zcat \ # Unzipps GZ compressed files, other options include bzcat for bzip2 files or samtools view when mapping from BAM alignments instead of FASTQ.
       --outFileNamePrefix ${stardir}/${base}-unsort. \ # Names output file
       --genomeDir ${genomedir} \  # Calls genomedir variable for path to genome file
       --readFilesIn ${trimdir}/${base}_trim_R1.fastq.gz ${trimdir}/${base}_trim_R2.fastq.gz # Picking input files (anything trimmed by fastp with the ending _trim_R1.fastq.gz)

done
