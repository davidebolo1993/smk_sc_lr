from glob import glob

rule cellranger_count_v701:
	input:
		ref=config['reference'],
		fq=lambda wildcards:glob('resources/fastq/illumina/{sample}/*'.format(sample=wildcards.sample))
	output:
		'results/ill_ont/cellranger/{sample}/outs/possorted_genome_bam.bam'
	threads:
		config['cellranger']['threads']
	resources:
		mem_mb=config['cellranger']['mem'],
		time=config['cellranger']['time']
	params:
		fq_folder='../../../resources/fastq/illumina/{sample}',
		sample_id='{sample}'
	container:
		'docker://edg1983/cellranger:v7.0.1'
	shell:
		'''
		cd results/ill_ont/cellranger \
		&& rm -rf {params.sample_id} \
		&& cellranger count \
			--id {params.sample_id} \
			--transcriptome {input.ref} \
			--fastqs {params.fq_folder} \
			--localcores {threads} \
			--localmem {resources.mem_mb}
		'''
