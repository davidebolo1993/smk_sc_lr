#!/bin/bash
set -x

#conda environemnt - load
eval "$(conda shell.bash hook)"
conda activate snakemakeenv_latest

#module -load
module load singularity/3.6.3

#run
bindings=$(cat evaluation/singularity_bind_paths.csv)
stringb=$(echo "-B $bindings")
snakemake --unlock
snakemake --profile config/slurm --singularity-args "$stringb" --snakefile workflow/Snakefile.evaluation evaluate_sicelore_data

