from glob import glob

rule cellranger_count:
	input:
		ref=config['reference'],
		fq=lambda wildcards:glob('resources/fastq/illumina/{sample}/*'.format(sample=wildcards.sample))
	output:
		bam='results/ill_ont/sicelore/cellranger/{sample}/outs/possorted_genome_bam',
		bc='results/ill_ont/sicelore/cellranger/{sample}/outs/filtered_feature_bc_matrix/barcodes.tsv.gz'
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
		cellranger count \
			--id {params.sample_id} \
			--transcriptome {input.ref} \
			--fastqs {params.fq_folder} \
			--localcores {threads} \
			--localmem {resources.mem_mb} \
		&& rm -rf {params.out_folder} \
		&& mv {params.sample_id} results/ill_ont/sicelore/cellranger/
		'''

