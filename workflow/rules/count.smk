from glob import glob

rule cellranger_count_v710:
	input:
		ref=config['reference'],
		fq=lambda wildcards:glob('resources/fastq/illumina/{sample}/*'.format(sample=wildcards.sample))
	output:
		'results/ill/cellranger/{sample}/outs/possorted_genome_bam.bam'
	threads:
		config['cellranger']['threads']
	resources:
		mem_mb=config['cellranger']['mem'],
		time=config['cellranger']['time']
	params:
		fq_folder='../../../resources/fastq/illumina/{sample}',
		sample_id='{sample}'
	container:
		'docker://edg1983/cellranger:v7.1.0'
	shell:
		'''
		cd results/ill/cellranger \
		&& rm -rf {params.sample_id} \
		&& cellranger count \
			--id {params.sample_id} \
			--transcriptome {input.ref} \
			--fastqs {params.fq_folder} \
			--localcores {threads} \
			--localmem {resources.mem_mb}
		'''
