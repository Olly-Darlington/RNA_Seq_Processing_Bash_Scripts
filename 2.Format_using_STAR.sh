#!/bin/bash
# Check sheband - which bash

# Load STAR
module load star/2.7.11b-conda

echo "check for formatted genome online before running, this WILL take a significant ammount of time and computational resource"

workdir=$(pwd)

## Change anything in ** ** to your project
# This is a highly RAM intensive process, run with caution - most routine genomes have a preformatted version availible from ensembl (https://ftp.ensembl.org/pub/current_fasta/).

STAR    --runThreadN **CPU thread assignment** \
        --limitGenomeGenerateRAM **assign RAM limit** \
        --runMode genomeGenerate \
        --genomeDir  **Genome location directory** \
        --genomeFastaFiles **genome fasta file location** \
        --sjdbGTFfile **GTF file location** \
        --sjdbOverhang **Length of your sequenncing data / 2 minus 1 **
