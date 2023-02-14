#!/bin/bash
set -x

#conda environemnt - load
eval "$(conda shell.bash hook)"
conda activate snakemakeenv_latest

#run
#snakemake --unlock
snakemake --profile config/slurm blaze_barcodes
