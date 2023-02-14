#!/bin/bash

cd $1

awk 'FS=","''{if ($3 >= 15) print $2}' putative_bc.csv | sort | uniq -c | awk '{print $1, $2"-1"}' OFS="\t" > cb.tsv
minval=$(grep -f whitelist.csv cb.tsv | sort -k1n | head -1 | cut -f 1)
awk -v var=$minval '{if ($1 >= var) print $2,"1",$1, "blaze_v110"; else print $2,"0",$1, "blaze_v110"}' OFS="\t" cb.tsv > bcs.tmp.tsv
sort -k3nr bcs.tmp.tsv | awk '{print NR, $1, $2, $3, $4}' OFS="\t" > bcs.tsv
rm cb.tsv bcs.tmp.tsv
