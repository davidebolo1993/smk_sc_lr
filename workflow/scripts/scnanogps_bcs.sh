#!/bin/bash

cd $1

touch seen.txt
zcat CB_merged_list.tsv.gz | tail -n+2 | while read ln; do
    
    n=$(echo $ln | cut -d ":" -f 1)
    rest=$(echo $ln | cut -d ":" -f 2)
    echo $rest | tr ';' '\n' | sed 's/^ //' | sed 's/^/^/' > take.idx
    zgrep -w -f take.idx CB_counting.tsv.gz > subset.tsv
    len=$(grep -c "^" subset.tsv)

    if [[ $len -gt 1 ]]; then #multiple entries

        idx=$(cut -f 1 subset.tsv | head -1) #best id, will be used for all the others
        grep -w ^$idx seen.txt > out.txt
        len2=$(grep -c "^" out.txt)  #check if best has been already seen

        if [[ $len2 -eq 0 ]]; then #not seen, compute

            sum=$(awk '{sum+=$3} END {print sum}' subset.tsv)
            head -1 subset.tsv | awk -v var=$sum '{print $2"-1", "1", var, "scnanogps_v100"}' OFS="\t" >> cb.tsv
            sed 's/^^//' take.idx >> seen.txt

        fi

        rm out.txt

    else #just one entry, cannot be seen

        awk '{print $2"-1", "1", $3, "scnanogps_v100"}' OFS="\t" subset.tsv >> cb.tsv
        sed 's/^^//' take.idx >> seen.txt

    fi

    rm take.idx subset.tsv

done

sed -i 's/^/^/' seen.txt
zcat CB_counting.tsv.gz | tail -n+2 | grep -v -w -f seen.txt | awk '{print $2"-1", "0", $3, "scnanogps_v100"}' OFS="\t" >> cb.tsv
sort -k3nr cb.tsv |awk '{print NR, $1, $2, $3, $4}' OFS="\t" > bcs.tsv
rm seen.txt cb.tsv