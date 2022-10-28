# Single-cell long-read sequenging using snakemake - run on slurm cluster

## Clone the repository`and activate environment

```
#clone
git clone --recursive https://github.com/davidebolo1993/smk_sc_lr
cd smk_sc_lr
#activate environment
module load singularity/3.6.3
conda activate snakemakeenv_latest
```

## Adjust samples

First, modify config/samples.tsv and config/config.yaml accordingly to the experimental settings. Following examples refers to settings included in the current repository (current paths make no sense for users outside HT's Population and Medical Genomics)

## cellranger count (v7.0.1)

```bash
snakemake --profile config/slurm --singularity-args "-B </path/to/directory.to.include>" cellranger
```

## wf-single-cell (v0.1.4 - with additional tweaks from my side)

```bash
snakemake --profile config/slurm wf-single-cell
```
