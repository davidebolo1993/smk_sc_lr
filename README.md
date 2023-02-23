# Single-cell long-read sequenging using snakemake

This documentation - with additional info - will be hosted [here](https://davidebolo1993.github.io/smk_sc_lr_doc) at some point

## Clone the repository and activate environment

```bash
#clone
git clone --recursive https://github.com/davidebolo1993/smk_sc_lr
cd smk_sc_lr
```

## Setting up

config/config.yaml and config/samples.tsv manually, then:

```bash
#print help
./workflow/scripts/prepare.sh
```

## Running individual rules on slurm cluster

