from glob import glob

rule cellranger_vdj_v710:
	input:
		ref=config['reference_vdj'],
		fq=lambda wildcards:glob('resources/illumina_vdj/{sample}/*'.format(sample=wildcards.sample))
	output:
		'results/ill/cellranger_vdj/{sample}/outs/consensus.bam'
	threads:
		config['cellranger']['threads']
	resources:
		mem_mb=config['cellranger']['mem'],
		time=config['cellranger']['time']
	params:
		fq_folder='../../../resources/illumina_vdj/{sample}',
		sample_id='{sample}',
		sample_id_2='{sample}'+'_TCR'
	container:
		'docker://edg1983/cellranger_vdj:v7.1.0'
	shell:
		'''
		cd results/ill/cellranger_vdj \
		&& rm -rf {params.sample_id} \
		&& cellranger vdj \
			--id {params.sample_id} \
			--reference {input.ref} \
			--fastqs {params.fq_folder} \
			--localcores {threads} \
			--localmem {resources.mem_mb} \
			--sample {params.sample_id_2}
		'''

