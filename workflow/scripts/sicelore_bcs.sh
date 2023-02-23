#!/bin/bash

cd $1

grep -f sicelore_ill/barcodes.csv umifinder_ill/BarcodesAssigned.tsv | cut -f 1-2 | sed 's/,//' | awk '{print $1"-1", "1", $2,"sicelore_v210+ill"}' OFS="\t"  > cb.tsv 
grep -v -f sicelore_ill/barcodes.csv umifinder_ill/BarcodesAssigned.tsv | tail -n +2 | sed 's/,//' | cut -f 1-2 | awk '{print $1"-1", "0", $2, "sicelore_v210+ill"}' OFS="\t" >> cb.tsv
sort -k3nr cb.tsv | awk '{print NR, $1, $2, $3, $4}' OFS="\t" > bcs.1.tsv
grep -f sicelore_noill/barcodes.csv umifinder_noill/BarcodesAssigned.tsv | cut -f 1-2 | sed 's/,//' | awk '{print $1"-1","1", $2,"sicelore_v210"}' OFS="\t" > cb.tsv 
grep -v -f sicelore_noill/barcodes.csv umifinder_noill/BarcodesAssigned.tsv | tail -n+2 | cut -f 1-2 | sed 's/,//' | awk '{print $1"-1", "0", $2,"sicelore_v210"}' OFS="\t" >> cb.tsv
sort -k3nr cb.tsv | awk '{print NR, $1, $2, $3, $4}' OFS="\t" > bcs.2.tsv
cat bcs.1.tsv bcs.2.tsv > bcs.tsv
rm bcs.1.tsv bcs.2.tsv cb.tsv
