# RNA_Seq_Processing_Bash_Scripts
A collection of 5 sequential bash scripts to deploy relevant modules and process RNA seq reads from raw data into feature counts for downstream differential gene expression analysis.

scripts are designed to be run sequentially, see module webpages or call 'man (module_name)' once loaded to see full list of specification functions.
Final output file is a series matrix file. For further use, annotations will need to be reconfigured to meet the demands of the downstream service. NCBI and SRA have tools capeable of extracting annotations from a series matrix file. A common downstream use is a SARTools DEG generation pipeline, such as seen in https://github.com/PF2-pasteur-fr/SARTools/blob/master/template_script_DESeq2.r

Module information:
Fastp : https://github.com/opengene/fastp
Fastqc : https://github.com/s-andrews/fastqc
Star : https://github.com/alexdobin/STAR
Picard : https://github.com/broadinstitute/picard
Samtools : https://www.htslib.org/
Subread : https://subread.sourceforge.net/
