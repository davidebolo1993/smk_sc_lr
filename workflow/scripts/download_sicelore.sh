#!/bin/bash

#download data from the Sicelore paper

###ILLUMINA

#https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE130708
#(Raw data are available in SRA)
#https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR9008424&display=metadata

module load sratoolkit/3.0.0

illbamdir="evaluation/data/sicelore_data/illumina/bam"
illfastqdir="evaluation/data/sicelore_data/illumina/HLH5CBGX5_HTHMLBGX3"
illbam=$illbamdir/"190c_possorted_genome_bam.bam"

mkdir -p $illbamdir

#download bam_file
wget -O $illbam https://sra-pub-src-1.s3.amazonaws.com/SRR9008424/190c_possorted_genome_bam.bam.1
#samtools index $illbam

#convert bam to fastq
wget -O evaluation/data/sicelore_data/illumina/bamtofastq_linux https://github.com/10XGenomics/bamtofastq/releases/download/v1.4.1/bamtofastq_linux
chmod +x evaluation/data/sicelore_data/illumina/bamtofastq_linux
evaluation/data/sicelore_data/illumina/bamtofastq_linux $illbam $illfastqdir
rm -rf $illbamdir

#ONT
#https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3748087
#(Raw data are available in SRA)
#https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR9008425&display=metadata

accession="SRR9008425"
nanofastqdir="evaluation/data/sicelore_data/nanopore/"$accession
mkdir -p $nanofastqdir && cd $nanofastqdir

prefetch $accession
fastq-dump $accession
rm -rf $accession

cd -
