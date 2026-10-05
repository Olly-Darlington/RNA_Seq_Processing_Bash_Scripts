#!/bin/bash
# check which bash before starting, change shebang as necessary


# assign necessary varibles
workdir=$(pwd) # ensure in relevant directory as the script assigns your current directory as the PWD

rawdir=${workdir}/rawdata # Change as necessary to the directory containing raw reads

mkdir ${workdir}/rawqc #  Create directory for Fastqc output
rawqcdir=${workdir}/rawqc
mkdir ${workdir}/trimdata #  Create directory for fastp output
trimdir=${workdir}/trimdata
mkdir ${workdir}/trimqc #  Create directory for second Fastqc output
trimqcdir=${workdir}/trimqc

# Load fastqc assuming module is already installed, change as necessary if using a package manager
module load fastqc

# Selects all fasta.gz files in the raw data directory 
for f in ${rawdir}/*_1.fastq.gz
do

# Splits names of fasta files 
R1=$(basename $f | cut -f1 -d.)
base=$(echo $R1 | sed 's/_1//')


# -t option assigns computational threads, fastqc is not a computationally heavy programme so 2 threads usually suffices.
fastqc -t 2 ${rawdir}/${base}_1.fastq.gz ${rawdir}/${base}_2.fastq.gz -o ${rawqcdir}

done
# Outputs HTML contaitning information about DNA reads, used to inform selection for trimming
#unload fastqc
module unload fastqc


#load program fastp - trims DNA reads 
module load fastp

# Re-establish loop for files
for f in ${rawdir}/*_1.fastq.gz
do

R1=$(basename $f | cut -f1 -d.)
base=$(echo $R1 | sed 's/_1//')

fastp -q 20 -u 10 --cut_right \
      -i ${rawdir}/${base}_1.fastq.gz \
      -I ${rawdir}/${base}_2.fastq.gz \
      -o ${trimdir}/${base}_trim_R1.fastq.gz \
      -O ${trimdir}/${base}_trim_R2.fastq.gz \
      -j ${trimdir}/${base}_trim.json \
      -h ${trimdir}/${base}_trim.html
# -q = phred quality score (default = 15), -u = Maximum percentage of unqualified bases allowed to keep a read (default = 40%)
# -i, -I = input specification (both needed for paired end reads), -o and -O = output specification.
# -j = json name output specification, -h = html name specification

done

#unload program
module unload fastp

# Repeat of first code block to redeploy fastqc on trimmed reads. output quality can now be compaired

module load fastqc

for f in ${rawdir}/*_1.fastq.gz
do

R1=$(basename $f | cut -f1 -d.)
base=$(echo $R1 | sed 's/_1//')

# Inputs trimmed files instead of raw data
fastqc -t 2 ${trimdir}/${base}_trim_R1.fastq.gz ${trimdir}/${base}_trim_R2.fastq.gz -o ${trimqcdir}

done

#unload  program
module unload fastqc

# Runs multiQC on directory, multiqc aggregates all log files and qc reports into an interactive, readable html
module load py-multiqc

multiqc ${workdir}

module unload py-multiqc
