import os
from glob import glob

rule blaze_v110:
	input:
		lambda wildcards:glob('resources/fastq/nanopore/{sample}/*'.format(sample=wildcards.sample))
	output:
		'results/ont/blaze/{sample}/whitelist.csv'
	threads:
		config['blaze']['threads']
	resources:
		mem_mb=config['blaze']['mem'],
		time=config['blaze']['time']
	params:
		out_folder='results/ont/blaze/{sample}',
		fq_folder='resources/fastq/nanopore/{sample}'
		cells=config['wf-single-cell']['expect_cells'],
		version=config['wf-single-cell']['version'],
		blaze=os.path.abspath('resources/BLAZE/bin/blaze.py')
	conda:
		'../envs/blaze-env.yml'
	shell:
		'''
		cd {params.out_folder} \
		&& python {params.blaze} \
			--expect-cells={params.cells} \
			--kit-version={params.version} \
			--threads={threads} \
			--batch-size=10000 \
			{params.fq_folder}
		'''