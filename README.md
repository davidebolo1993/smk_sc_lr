# Single-cell long-read sequenging using snakemake

This documentation - with additional info - will be hosted [here](https://davidebolo1993.github.io/smk_sc_lr_doc) at some point

## Clone the repository`and activate environment

```bash
#clone
git clone --recursive https://github.com/davidebolo1993/smk_sc_lr
cd smk_sc_lr
#update submodules - this is optional
git submodule update --remote --merge
#for people in the Population and Medical Genomics Unit at HT - otherwise a working singularity and snakemake installation - with some basica python libraries with pandas/numpy should work as well
module load singularity/3.6.3
conda activate snakemakeenv_latest
```

## Setting up

Either adjust config/config.yaml and config/samples.tsv manually or using the dedicated script:

```bash
#print help
./prepare.sh
#prepare con
./prepare.sh ./prepare.sh -r /path/to/10x/reference_folder -i /path/to/illumina/fastq_folder -n /path/to/nanopore/fastq_folder -k <5prime,3prime> -e <v1,v2/v3> -c <cells> #-k,-e and -v can be omitted, default values are -k 5prime -v v1 -e 10000
```

## Running individual rules on slurm cluster

```bash
#cellranger from 10xGenomics (v7.0.1)
snakemake --profile config/slurm --singularity-args "-B /path/to/10x/reference_folder,/path/to/illumina/fastq_folder" cellranger
```

```bash
#wf-single-cell from epi2me-labs (v0.1.4 - with additional tweaks from my side)
snakemake --profile config/slurm --singularity-args "-B /path/to/10x/reference_folder,/path/to/nanopore/fastq_folder,/localscratch" wf_single_cell
```
