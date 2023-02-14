#!/bin/bash

cd $1

samtools view possorted_genome_bam.bam | awk '{for (i=12; i<=NF; ++i) { if ($i ~ "^CB:"){ split($i, tc, ":"); td[tc[1]] = tc[3]; } }; print td["CB"] }' | sort | uniq -c | awk '{print $1, $2}' OFS="\t" > cb.tsv
grep -f <(zcat filtered_feature_bc_matrix/barcodes.tsv.gz) cb.tsv | awk '{print $2, "1", $1, "cellranger_v710"}' OFS="\t" >> bcs.tmp.tsv
grep -v -f <(zcat filtered_feature_bc_matrix/barcodes.tsv.gz) cb.tsv | awk '{print $2, "0", $1, "cellranger_v710"}' OFS="\t" >> bcs.tmp.tsv
sort -k3nr bcs.tmp.tsv | awk '{print NR, $1, $2, $3, $4}' OFS="\t" > bcs.tsv
rm cb.tsv bcs.tmp.tsv
