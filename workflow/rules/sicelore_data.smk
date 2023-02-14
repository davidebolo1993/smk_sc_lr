from glob import glob

rule cellranger_count_v701:
	input:
		ref=config['reference'],
		fq= glob('evaluation/data/sicelore_data/illumina/HLH5CBGX5_HTHMLBGX3/*/*')
	output:
		'evaluation/results/sicelore_data/cellranger/HLH5CBGX5_HTHMLBGX3/outs/possorted_genome_bam.bam'
	threads:
		config['sicelcore_data']['threads']
	resources:
		mem_mb=config['sicelcore_data']['mem'],
		time=config['sicelcore_data']['time']
	params:
		fq_folder='../../../data/sicelore_data/illumina/HLH5CBGX5_HTHMLBGX3',
		sample_id='HLH5CBGX5_HTHMLBGX3'
	container:
		'docker://edg1983/cellranger:v7.0.1'
	shell:
		'''
		cd evaluation/results/sicelore_data/cellranger/ \
		&& rm -rf {params.sample_id} \
		&& cellranger count \
			--id {params.sample_id} \
			--transcriptome {input.ref} \
			--fastqs {params.fq_folder} \
			--localcores {threads} \
			--localmem {resources.mem_mb}
		'''

rule wf_single_cell_v020:
	input:
		ref=config['reference'],
		fq='evaluation/data/sicelore_data/nanopore/SRR9008425/SRR9008425.fastq'
	output:
		genes='evaluation/results/sicelore_data/wf-single-cell/SRR9008425/SRR9008425/SRR9008425.gene_expression.counts.tsv',
		transcripts='evaluation/results/sicelore_data/wf-single-cell/SRR9008425/SRR9008425/SRR9008425.transcript_expression.counts.tsv'
	threads:
		config['sicelcore_data']['threads']
	resources:
		mem_mb=config['sicelcore_data']['mem'],
		time=config['sicelcore_data']['time']
	params:
		out_folder='evaluation/results/sicelore_data/wf-single-cell/SRR9008425',
		fq_folder='evaluation/data/sicelore_data/nanopore/SRR9008425',
		sample_sheet='evaluation/data/sicelore_data/wf-single-cell.sheet.csv'
	container:
		'docker://davidebolo1993/wf-single-cell:latest'
	shell:
		'''
		nextflow run resources/wf-single-cell \
			-w {params.out_folder}/workspace \
			-profile local \
			-c evaluation/wf-single-cell.config \
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

rule blaze_v110:
	input:
		'evaluation/data/sicelore_data/nanopore/SRR9008425/SRR9008425.fastq'
	output:
		'evaluation/results/sicelore_data/blaze/SRR9008425/whitelist.csv'
	threads:
		config['sicelcore_data']['threads']
	resources:
		mem_mb=config['sicelcore_data']['mem'],
		time=config['sicelcore_data']['time']
	params:
		out_folder='evaluation/results/sicelore_data/blaze/SRR9008425',
		fq_folder='../../../../data/sicelore_data/nanopore/SRR9008425',
		cells=config['sicelcore_data']['expect_cells'],
		version=config['sicelcore_data']['version'],
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

rule knee_data_blaze:
	input:
		rules.blaze_v110.output
	output:
		'evaluation/results/sicelore_data/blaze/SRR9008425/bcs.tsv'
	threads:
		1
	shell:
		'''
		bash workflow/scripts/blaze_bcs.sh evaluation/results/sicelore_data/blaze/SRR9008425
		'''

rule knee_data_cellranger:
	input:
		rules.cellranger_count_v701.output
	output:
		'evaluation/results/sicelore_data/cellranger/HLH5CBGX5_HTHMLBGX3/outs/bcs.tsv'
	threads:
		1
	shell:
		'''
		bash workflow/scripts/cellranger_bcs.sh evaluation/results/sicelore_data/cellranger/HLH5CBGX5_HTHMLBGX3/outs
		'''

rule knee_data_wf_single_cell:
	input:
		rules.wf_single_cell_v020.output
	output:
		'evaluation/results/sicelore_data/wf-single-cell/SRR9008425/SRR9008425/bcs.tsv'
	threads:
		1
	shell:
		'''
		bash workflow/scripts/wf-single-cell_bcs.sh evaluation/results/sicelore_data/wf-single-cell/SRR9008425/SRR9008425
		'''

rule combine_knee_data:
	input:
		rules.knee_data_blaze.output, rules.knee_data_cellranger.output, rules.knee_data_wf_single_cell.output
	output:
		'evaluation/results/sicelore_data/bcs.tsv'
	threads:
		1
	shell:
		'''
		cat {input} > {output}
		'''

rule plot_knee_data:
	input:
		rules.combine_knee_data.output
	output:
		'evaluation/results/sicelore_data/evaluation.pdf'
	threads:
		1
	conda:
		'../envs/r-env.yml'
	shell:
		'''
		Rscript workflow/scripts/plotevaluation.r {input} {output}
		'''
