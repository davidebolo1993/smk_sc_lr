#!/bin/bash

usage() { echo "Usage: $0 [-r </path/to/10x/reference_folder>] [-i </path/to/illumina/fastq_folder>] [-n </path/to/nanopore/fastq_folder>] [-k <kit.string>] [-e <kit.version.string>] [-c <cells.int>]" 1>&2; exit 1; }

while getopts ":r:i:n:k:e:c:" opt; do
    case "${opt}" in
        r)
            r=${OPTARG}
            ;;
        i)
            i=${OPTARG}
            ;;
	n)
            n=${OPTARG}
            ;;
	k)
	    k=${OPTARG}
	    ;;
	e)
	    e=${OPTARG}
	    ;;
	c)
            c=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${r}" ]; then
	echo "missing 10x reference folder" && usage
elif [ -z "${n}" ]; then
	echo "missing nanopore fastq folder" && usage
elif [ -z "${i}" ]; then
	echo "missing illumina fastq folder, assuming only nanopore data are available"
fi


if [ -z "${e}" ]; then
	e="v1"
fi

if [ -z "${k}" ]; then
	k="5prime"
fi

if [ -z "${c}" ]; then
	c="10000"
fi

echo "10x reference folder: " $r
echo "nanopore fastq folder: " $n
echo "illumina fastq folder: " $i
echo "kit type: " $k
echo "kit version: " $e
echo "expected cells: " $c

if [ ! -z "${i}" ]; then

	fold=$(find $i -maxdepth 1 -type d -name "*" -not -name $(basename $i))

	if [ -z "${fold}" ]; then

		fold=$(find $i -maxdepth 1 -type d -name "*")

	fi

	for f in $fold; do

		#dirname=$(basename -- "$f")
		abspath=$(readlink -f $f)
		files=$(find $f -type f -name "*" -print -quit)
		id=$(basename $files | cut -d "_" -f 1)
		echo -e $id"\t"$abspath"\tILL" >> config/illumina.samples.tsv

	done

fi

fold=$(find $n -maxdepth 1 -type d -name "*" -not -name $(basename $n))

if [ -z "${fold}" ]; then

	fold=$(find $n -maxdepth 1 -type d -name "*")

fi

for f in $fold; do

	#dirname=$(basename -- "$f")
        abspath=$(readlink -f $f)
	files=$(find $f -type f -name "*" -print -quit)
        id=$(basename $files | cut -d "_" -f 1-2)
	echo -e $id"\t"$abspath"\tONT" >> config/nanopore.samples.tsv

done

echo -e "sample_id\tsample_fastq_dir\tsample_type" > config/samples.tsv
cat config/illumina.samples.tsv config/nanopore.samples.tsv >> config/samples.tsv 
rm config/illumina.samples.tsv config/nanopore.samples.tsv

abspath=$(readlink -f $r)

#modify config
sed -i 's,reference:,reference: '"$abspath"',g' config/config.yaml
sed -i 's,kit:,kit: '"$k"',g' config/config.yaml
sed -i 's,version:,version: '"$e"',g' config/config.yaml
sed -i 's,expect_cells:,expect_cells: '"$c"',g' config/config.yaml
