#!/bin/bash

cd logs

touch ../evaluation/results/scmixology2_data/stats.tsv
echo -e "category\tbroad_category\tvalue\ttool" >> ../evaluation/results/scmixology2_data/stats.tsv

#blaze
log="blaze_v110_bis/blaze_v110_bis--2134161.out"
id=$(echo $log | cut -d "-" -f 3 | cut -d "." -f 1)
cpu_usage=$(seff $id | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours=$(bc <<< "scale=4; $cpu_usage/3600")
ctime=$(seff $id | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours=$(bc <<< "scale=4; $ctime/3600")
wtime=$(seff $id | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours=$(bc <<< "scale=4; $wtime/3600")
memory=$(seff $id | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

echo -e "cpu_usage\ttime\t$cpu_usage_hours\tblaze_v110" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "clock_time\ttime\t$wtime_hours\tblaze_v110" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "core_time\ttime\t$ctime_hours\tblaze_v110" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "memory_peak\tmemory\t$memory\tblaze_v110" >> ../evaluation/results/scmixology2_data/stats.tsv

#cellranger
log="cellranger_count_v710_bis/cellranger_count_v710_bis--2134162.out"
id=$(echo $log | cut -d "-" -f 3 | cut -d "." -f 1)
cpu_usage=$(seff $id | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours=$(bc <<< "scale=4; $cpu_usage/3600")
ctime=$(seff $id | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours=$(bc <<< "scale=4; $ctime/3600")
wtime=$(seff $id | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours=$(bc <<< "scale=4; $wtime/3600")
memory=$(seff $id | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

echo -e "cpu_usage\ttime\t$cpu_usage_hours\tcellranger_v710" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "clock_time\ttime\t$wtime_hours\tcellranger_v710" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "core_time\ttime\t$ctime_hours\tcellranger_v710" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "memory_peak\tmemory\t$memory\tcellranger_v710" >> ../evaluation/results/scmixology2_data/stats.tsv

#sicelore + ill
log1="sicelore_scanfastq_ill_v210_bis/sicelore_scanfastq_ill_v210_bis--2134403.out"

id1=$(echo $log1 | cut -d "-" -f 3 | cut -d "." -f 1)
cpu_usage1=$(seff $id1 | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours1=$(bc <<< "scale=4; $cpu_usage1/3600")
ctime1=$(seff $id1 | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours1=$(bc <<< "scale=4; $ctime1/3600")
wtime1=$(seff $id1 | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours1=$(bc <<< "scale=4; $wtime1/3600")
memory1=$(seff $id1 | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

log2="sicelore_sicelore_ill_v210_bis/sicelore_sicelore_ill_v210_bis--2134421.out"

id2=$(echo $log2 | cut -d "-" -f 3 | cut -d "." -f 1)
cpu_usage2=$(seff $id2 | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours2=$(bc <<< "scale=4; $cpu_usage2/3600")
ctime2=$(seff $id2 | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours2=$(bc <<< "scale=4; $ctime2/3600")
wtime2=$(seff $id2 | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours2=$(bc <<< "scale=4; $wtime2/3600")
memory2=$(seff $id2 | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

cpu_usage_hours=$(bc <<< "scale=4; $cpu_usage_hours1 +$cpu_usage_hours2 ")
ctime_hours=$(bc <<< "scale=4; $ctime_hours1 + $ctime_hours2")
wtime_hours=$(bc <<< "scale=4; $wtime_hours1 + $wtime_hours2")
memory=$(bc <<< "scale=4; $memory1 + $memory2")

echo -e "cpu_usage\ttime\t$cpu_usage_hours\tsicelore_v210+ill" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "clock_time\ttime\t$wtime_hours\tsicelore_v210+ill" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "core_time\ttime\t$ctime_hours\tsicelore_v210+ill" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "memory_peak\tmemory\t$memory\tsicelore_v210+ill" >> ../evaluation/results/scmixology2_data/stats.tsv

#sicelore
log1="sicelore_scanfastq_noill_v210_bis/sicelore_scanfastq_noill_v210_bis--2134164.out"
cpu_usage1=$(seff $id1 | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours1=$(bc <<< "scale=4; $cpu_usage1/3600")
ctime1=$(seff $id1 | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours1=$(bc <<< "scale=4; $ctime1/3600")
wtime1=$(seff $id1 | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours1=$(bc <<< "scale=4; $wtime1/3600")
memory1=$(seff $id1 | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

log2="sicelore_sicelore_noill_v210_bis/sicelore_sicelore_noill_v210_bis--2134273.out"
id2=$(echo $log2 | cut -d "-" -f 3 | cut -d "." -f 1)
cpu_usage2=$(seff $id2 | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours2=$(bc <<< "scale=4; $cpu_usage2/3600")
ctime2=$(seff $id2 | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours2=$(bc <<< "scale=4; $ctime2/3600")
wtime2=$(seff $id2 | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours2=$(bc <<< "scale=4; $wtime2/3600")
memory2=$(seff $id2 | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

cpu_usage_hours=$(bc <<< "scale=4; $cpu_usage_hours1 +$cpu_usage_hours2 ")
ctime_hours=$(bc <<< "scale=4; $ctime_hours1 + $ctime_hours2")
wtime_hours=$(bc <<< "scale=4; $wtime_hours1 + $wtime_hours2")
memory=$(bc <<< "scale=4; $memory1 + $memory2")

echo -e "cpu_usage\ttime\t$cpu_usage_hours\tsicelore_v210" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "clock_time\ttime\t$wtime_hours\tsicelore_v210" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "core_time\ttime\t$ctime_hours\tsicelore_v210" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "memory_peak\tmemory\t$memory\tsicelore_v210" >> ../evaluation/results/scmixology2_data/stats.tsv

#scnanogps
log1="scnanogps_scanner_v100_bis/scnanogps_scanner_v100_bis--2134165.out"

cpu_usage1=$(seff $id1 | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours1=$(bc <<< "scale=4; $cpu_usage1/3600")
ctime1=$(seff $id1 | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours1=$(bc <<< "scale=4; $ctime1/3600")
wtime1=$(seff $id1 | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours1=$(bc <<< "scale=4; $wtime1/3600")
memory1=$(seff $id1 | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

log2="scnanogps_assigner_v100_bis/scnanogps_assigner_v100_bis--2134494.out"

id2=$(echo $log2 | cut -d "-" -f 3 | cut -d "." -f 1)
cpu_usage2=$(seff $id2 | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours2=$(bc <<< "scale=4; $cpu_usage2/3600")
ctime2=$(seff $id2 | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours2=$(bc <<< "scale=4; $ctime2/3600")
wtime2=$(seff $id2 | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours2=$(bc <<< "scale=4; $wtime2/3600")
memory2=$(seff $id2 | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

cpu_usage_hours=$(bc <<< "scale=4; $cpu_usage_hours1 +$cpu_usage_hours2 ")
ctime_hours=$(bc <<< "scale=4; $ctime_hours1 + $ctime_hours2")
wtime_hours=$(bc <<< "scale=4; $wtime_hours1 + $wtime_hours2")
memory=$(bc <<< "scale=4; $memory1 + $memory2")

echo -e "cpu_usage\ttime\t$cpu_usage_hours\tscnanogps_v100" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "clock_time\ttime\t$wtime_hours\tscnanogps_v100" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "core_time\ttime\t$ctime_hours\tscnanogps_v100" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "memory_peak\tmemory\t$memory\tscnanogps_v100" >> ../evaluation/results/scmixology2_data/stats.tsv

#wf-single-cell
log="wf_single_cell_v020_bis/wf_single_cell_v020_bis--2134163.out"
id=$(echo $log | cut -d "-" -f 3 | cut -d "." -f 1)
cpu_usage=$(seff $id | grep "CPU Utilized:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
cpu_usage_hours=$(bc <<< "scale=4; $cpu_usage/3600")
ctime=$(seff $id | grep "CPU Efficiency:" | cut -d ":" -f 2- |  cut -d "f" -f 2 | cut -d "c" -f 1  |  sed 's/ *//g' |awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
ctime_hours=$(bc <<< "scale=4; $ctime/3600")
wtime=$(seff $id | grep "Job Wall-clock time:" | cut -d ":" -f 2- | sed 's/ *//g' | awk -F'[:-]' '{if (NF == 3) print ($1 * 3600) + ($2 * 60) + $3; else print ($1 * 3600*24) + ($2 * 3600) + ($3*60) + $4}')
wtime_hours=$(bc <<< "scale=4; $wtime/3600")
memory=$(seff $id | grep "Memory Utilized:" | cut -d ":" -f 2- | cut -d "G" -f 1 |sed 's/ *//g')

echo -e "cpu_usage\ttime\t$cpu_usage_hours\twf-single-cell_v020" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "clock_time\ttime\t$wtime_hours\twf-single-cell_v020" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "core_time\ttime\t$ctime_hours\twf-single-cell_v020" >> ../evaluation/results/scmixology2_data/stats.tsv
echo -e "memory_peak\tmemory\t$memory\twf-single-cell_v020" >> ../evaluation/results/scmixology2_data/stats.tsv

