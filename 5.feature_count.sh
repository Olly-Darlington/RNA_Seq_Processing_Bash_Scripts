#!/bin/bash

# Load modules
module load subread/2.0.6-hbzwdut

workdir=$(pwd)
rawdir=${workdir}/rawdata
trimdir=${workdir}/trimdata
stardir=${workdir}/star
genomedir=**reference genome location**
markdir=${workdir}/markdup

# make feature counts directory and assign it to the fcdir variable
mkdir ${workdir}/featureCounts
fcdir=${workdir}/featureCounts

#same loop to pick files
for f in ${workdir}/rawdata/*_1.fastq.gz
do
R1=$(basename $f | cut -f1 -d.)
base=$(echo $R1 | sed 's/_1//')

# Call featurecounts function with duplicates INCLUDED
featureCounts \
-T 4 -p -F GTF -t exon -g gene_id \ # -t = threads, -F = reference file type, -t = sumarise to exons as genomic feature, -g = sumarise to entire gene groups grouped by GeneID
-a ${genomedir}/**reference genome file** \
-o ${fcdir}/${base}.markdup.featurecount \ # Output file name (with duplicates)
 ${markdir}/${base}.markdup.bam # Input file name (with duplicates)

# Call featurecounts function with duplicates EXCLUDED
featureCounts \
-T 4 -p -F GTF -t exon -g gene_id \
-a ${genomedir}/**reference genome file** \
-o ${fcdir}/${base}.rmdup.featurecount \ # Output file name (without duplicates)
${markdir}/${base}.rmdup.bam # Input file name (without duplicates)

done
