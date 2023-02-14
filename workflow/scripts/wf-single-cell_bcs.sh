#!/bin/bash

cd $1

tail -n +2 *_read_tags.tsv | cut -f 4 | sort | uniq -c | awk 'OFS="\t"''{print $2"-1", $1, "1"}' > consensus.tsv
samtools view bams/*.bam | awk '{for (i=12; i<=NF; ++i) { if ($i ~ "^CR:"){ split($i, tc, ":"); td[tc[1]] = tc[3]; } }; print td["CR"] }' | sort | uniq -c | awk '{print $2"-1", $1}' OFS="\t" > cb.tsv
grep -v -f <(cut -f1 consensus.tsv) cb.tsv | awk '{print $1, "0", $2, "wf-single-cell_v020"}' OFS="\t" > fail.tsv
grep -f <(cut -f1 consensus.tsv) cb.tsv | awk '{print $1, "1", $2, "wf-single-cell_v020"}' OFS="\t" > pass.tsv
cat pass.tsv fail.tsv > bcs.tmp.tsv
sort -k3nr bcs.tmp.tsv | awk '{print NR, $1, $2, $3, $4}' OFS="\t" > bcs.tsv
rm pass.tsv fail.tsv cb.tsv consensus.tsv bcs.tmp.tsv
