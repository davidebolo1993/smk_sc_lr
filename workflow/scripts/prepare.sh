#!/bin/bash

config="config/config.yaml"
samples="config/samples.tsv"

#get reference from samples.tsv
refdir=$(grep -w "reference" $config | cut -d ":" -f 2  | sed 's/ *//g')
vdjrefdir=$(grep -w "reference_vdj" $config | cut -d ":" -f 2  | sed 's/ *//g')
#get paths for samples
echo "/localscratch" > singularity_bind_paths.tmp.csv

#kit,version,cells
mkdir -p resources/single-cell-sample-sheet
kit=$(grep "kit:" $config | cut -d "#" -f 1 | cut -d ":" -f 2| sed 's/ *//g')
version=$(grep "version:" $config | cut -d "#" -f 1 | cut -d ":" -f 2| sed 's/ *//g')
cells=$(grep "expect_cells:" $config | cut -d "#" -f 1 | cut -d ":" -f 2| sed 's/ *//g')

tail -n+2 $samples | while IFS=$'\t' read -r name sample_type files; do

	IFS=',' read -r -a array <<< "$files"
	for element in "${array[@]}"; do  dirname "$element" >> singularity_bind_paths.tmp.csv ; done

	if [ ! -d resources/$sample_type/$name ]; then

		mkdir -p resources/$sample_type/$name
		echo $name","$sample_type",$files"
		if [ "$sample_type" == "ont" ]; then echo "sample_id,kit_name,kit_version,exp_cells" > resources/single-cell-sample-sheet/$name".single_cell_sample_sheet.csv" && echo $name","$kit","$version","$cells >> resources/single-cell-sample-sheet/$name".single_cell_sample_sheet.csv"; fi
		#iterate over single files
		for element in "${array[@]}"; do for f in $element; do b=$(basename $f) && ln -sf $(readlink -f $f) resources/$sample_type/$name/$b; done; done

	fi
done

echo "$refdir" >> singularity_bind_paths.tmp.csv
echo "$vdjrefdir" >> singularity_bind_paths.tmp.csv
cat singularity_bind_paths.tmp.csv | sort | uniq | tr '\n' ',' > singularity_bind_paths.csv && rm singularity_bind_paths.tmp.csv

cpus=$(grep -A 3 "wf-single-cell:" $config | grep "threads" | cut -d "#" -f 1 | cut -d ":" -f 2| sed 's/ *//g')
mem=$(grep -A 3 "wf-single-cell:" $config | grep "mem" | cut -d "#" -f 1 | cut -d ":" -f 2| sed 's/ *//g')
memGB=$(echo $((mem / 1024)))

mkdir -p resources/single-cell-resources/
echo -e "executor {\n\t\$local {\n\t\tcpus = $cpus\n\t\tmemory = \"$memGB"GB"\"\n\t}\n}" > resources/single-cell-resources/wf-single-cell.config

