from glob import glob

rule cellranger_count:
	input:
		ref=config['reference'],
		fq=lambda wildcards:glob('resources/fastq/illumina/{sample}/*'.format(sample=wildcards.sample))
	output:
		'results/ill_ont/sicelore/cellranger/{sample}/outs/possorted_genome_bam'
	threads:
		config['cellranger']['threads']
	resources:
		mem_mb=config['cellranger']['mem'],
		time=config['cellranger']['time']
	params:
		fq_folder='resources/fastq/illumina/{sample}',
		sample_id='{sample}',
		out_folder='results/ill_ont/sicelore/cellranger/{sample}'
	container:
		'docker://edg1983/cellranger:v7.0.1'
	shell:
		'''
		rm -rf {params.out_folder} \
		&& cellranger count \
			--id {params.sample_id} \
			--transcriptome {input.ref} \
			--fastqs {params.fq_folder} \
			--localcores {threads} \
			--localmem {resources.mem_mb} \
		&& mv {params.sample_id} results/ill_ont/sicelore/cellranger/{params.sample_id}
		'''

