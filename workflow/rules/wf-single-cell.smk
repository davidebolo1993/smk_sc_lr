from glob import glob


rule wf_single_cell_v016:
	input:
		ref=config['reference'],
		fq=lambda wildcards:glob('resources/fastq/nanopore/{sample}/*'.format(sample=wildcards.sample))
	output:
		'results/ont/wf-single-cell/{sample}/{sample}.gene_expression.counts.tsv'
	threads:
		config['wf-single-cell']['threads']
	resources:
		mem_mb=config['wf-single-cell']['mem'],
		time=config['wf-single-cell']['time']
	params:
		out_folder='results/ont/wf-single-cell/{sample}',
		fq_folder='resources/fastq/nanopore/{sample}',
		sample_sheet='resources/single-cell-sample-sheet/{sample}.single_cell_sample_sheet.csv'
	container:
		'docker://davidebolo1993/wf-single-cell:latest'
	shell:
		'''
		nextflow run resources/wf-single-cell \
			-w {params.out_folder}/workspace \
			-profile local \
			-c resources/single-cell-resources/wf-single-cell.config \
			--fastq {params.fq_folder} \
			--single_cell_sample_sheet {params.sample_sheet} \
			--ref_genome_dir {input.ref} \
			--out_dir {params.out_folder} \
			--matrix_min_genes 1 \
			--matrix_min_cells 1 \
			--matrix_max_mito 100 \
			--max_threads {threads} \
			--umi_cluster_max_threads {threads} \
			--resources_mm2_max_threads {threads} \
			--merge_bam
		'''

