# Single-cell long-read sequenging using snakemake

This documentation - with additional info - will be hosted [here](https://davidebolo1993.github.io/smk_sc_lr_doc) at some point

## Clone the repository`and activate environment

```bash
#clone
git clone --recursive https://github.com/davidebolo1993/smk_sc_lr
cd smk_sc_lr
```

## Setting up

Either adjust config/config.yaml and config/samples.tsv manually or using the dedicated script:

```bash
#print help
./workflow/scripts/prepare.sh
#prepare con
.workflow/scripts/prepare.sh -r /path/to/10x/reference_folder -i /path/to/illumina/fastq_folder -n /path/to/nanopore/fastq_folder -k <5prime,3prime> -e <v1,v2/v3> -c <cells> #-k,-e and -v can be omitted, default values are -k 5prime -v v1 -e 10000
```

## Running individual rules on slurm cluster

Requires snakemake (with some additional packages - that will be added in the end) and singularity.

```bash
#cellranger from 10xGenomics (v7.0.1)
snakemake --profile config/slurm --singularity-args "-B /path/to/10x/reference_folder,/path/to/illumina/fastq_folder" cellranger_count

#a more convenient way for PopMed ppl
./workflow/scripts/runcount.sh
```

```bash
#wf-single-cell from epi2me-labs (v0.1.6)
snakemake --profile config/slurm --singularity-args "-B /path/to/10x/reference_folder,/path/to/nanopore/fastq_folder,/localscratch" wf_single_cell

#a more convenient way for PopMed ppl
./workflow/scripts/runont.sh
```
