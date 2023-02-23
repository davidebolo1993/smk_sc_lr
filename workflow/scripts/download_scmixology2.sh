#!/bin/bash

#download data from the scmixology2 paper

###ILLUMINA

#https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE154870
#(Raw data are available in SRA)
#https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR12282462&display=metadata

module load sratoolkit/3.0.0

illfastqdir="evaluation/data/scmixology2_data/illumina/"
accession="SRR12282462"
mkdir -p $illfastqdir"/"$accession
cd $illfastqdir"/"$accession
fastq-dump --split-files --gzip $accession
rm -rf $accession
#convert to cellranger format
mv SRR12282462_1.fastq.gz SRR12282462_S1_L001_R1_001.fastq.gz
mv SRR12282462_2.fastq.gz SRR12282462_S1_L001_R2_001.fastq.gz
cd -

#ONT
#https://ftp.sra.ebi.ac.uk/vol1/run/ERR995/ERR9958136/LR_sc-RNA-seq_SCMIXOLOGY2_pass.fastq.gz

nanofastqdir="evaluation/data/scmixology2_data/nanopore"
accession="ERR9958136"
mkdir -p $nanofastqdir"/"$accession
cd $nanofastqdir"/"$accession
wget https://ftp.sra.ebi.ac.uk/vol1/run/ERR995/ERR9958136/LR_sc-RNA-seq_SCMIXOLOGY2_pass.fastq.gz
cd -
