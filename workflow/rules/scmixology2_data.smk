from glob import glob

rule cellranger_count_v710_bis:
	input:
		ref=config['reference'],
		fq= glob('evaluation/data/scmixology2_data/illumina/SRR12282462/*/*')
	output:
		'evaluation/results/scmixology2_data/cellranger/SRR12282462/outs/possorted_genome_bam.bam'
	threads:
		config['scmixology2_data']['threads']
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	params:
		fq_folder='../../../data/scmixology2_data/illumina/SRR12282462',
		sample_id='SRR12282462'
	container:
		'docker://edg1983/cellranger:v7.1.0'
	shell:
		'''
		cd evaluation/results/scmixology2_data/cellranger/ \
		&& rm -rf {params.sample_id} \
		&& cellranger count \
			--id {params.sample_id} \
			--transcriptome {input.ref} \
			--fastqs {params.fq_folder} \
			--localcores {threads} \
			--localmem {resources.mem_mb}
		'''

rule wf_single_cell_v020_bis:
	input:
		ref=config['reference'],
		fq='evaluation/data/scmixology2_data/nanopore/ERR9958136/LR_sc-RNA-seq_SCMIXOLOGY2_pass.fastq.gz'
	output:
		genes='evaluation/results/scmixology2_data/wf-single-cell/ERR9958136/ERR9958136/ERR9958136.gene_expression.counts.tsv',
		transcripts='evaluation/results/scmixology2_data/wf-single-cell/ERR9958136/ERR9958136/ERR9958136.transcript_expression.counts.tsv'
	threads:
		config['scmixology2_data']['threads']
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	params:
		out_folder='evaluation/results/scmixology2_data/wf-single-cell/ERR9958136',
		fq_folder='evaluation/data/scmixology2_data/nanopore/ERR9958136',
		sample_sheet='evaluation/data/scmixology2_data/wf-single-cell.sheet.csv'
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

rule blaze_v110_bis:
	input:
		'evaluation/data/scmixology2_data/nanopore/ERR9958136/LR_sc-RNA-seq_SCMIXOLOGY2_pass.fastq.gz'
	output:
		'evaluation/results/scmixology2_data/blaze/ERR9958136/whitelist.csv'
	threads:
		config['scmixology2_data']['threads']
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	params:
		out_folder='evaluation/results/scmixology2_data/blaze/ERR9958136',
		fq_folder='../../../../data/scmixology2_data/nanopore/ERR9958136',
		cells=config['scmixology2_data']['expect_cells'],
		version=config['scmixology2_data']['version'],
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

rule scnanogps_scanner_v100_bis:
	input:
		'evaluation/data/scmixology2_data/nanopore/ERR9958136/LR_sc-RNA-seq_SCMIXOLOGY2_pass.fastq.gz'
	output:
		tsv='evaluation/results/scmixology2_data/scnanogps/ERR9958136/scanner/barcode_list.tsv.gz',
		fq='evaluation/results/scmixology2_data/scnanogps/ERR9958136/scanner/processed.fastq.gz'
	threads:
		config['scmixology2_data']['threads']
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	params:
		in_folder='evaluation/data/scmixology2_data/nanopore/ERR9958136',
		out_folder='evaluation/results/scmixology2_data/scnanogps/ERR9958136/scanner'
	container:
		'docker://edg1983/scnanogps:v100'
	shell:
		'''
		python3 resources/scNanoGPS/scanner.py -i {params.in_folder} -d {params.out_folder} -t {threads} --lUMI 12 --lCB 16 --batching_no 10000
		'''

rule scnanogps_assigner_v100_bis:
	input:
		rules.scnanogps_scanner_v100_bis.output.tsv
	output:
		'evaluation/results/scmixology2_data/scnanogps/ERR9958136/assigner/CB_counting.tsv.gz',
	threads:
		config['scmixology2_data']['threads']
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	params:
		out_folder='evaluation/results/scmixology2_data/scnanogps/ERR9958136/assigner'
	container:
		'docker://edg1983/scnanogps:v100'
	shell:
		'''
		cd {params.out_folder} \
		&& cp ../scanner/barcode_list.tsv.gz . \
		&& python3 ../../../../../../resources/scNanoGPS/assigner.py -i barcode_list.tsv.gz -d . --lCB 16 -t {threads} 
		'''

rule sicelore_scanfastq_noill_v210_bis:
	input:
		'evaluation/data/scmixology2_data/nanopore/ERR9958136/LR_sc-RNA-seq_SCMIXOLOGY2_pass.fastq.gz'
	output:
		'evaluation/results/scmixology2_data/sicelore/ERR9958136/umifinder_noill/BarcodesAssigned.tsv'
	threads:
		config['scmixology2_data']['threads']
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	params:
		in_folder='evaluation/data/scmixology2_data/nanopore/ERR9958136',
		out_folder='evaluation/results/scmixology2_data/sicelore/ERR9958136/umifinder_noill',
		in_barcodes='resources/sicelore-2.1/Jar/3M-february-2018.txt.gz'
	container:
		'docker://edg1983/sicelore:v2.1'
	shell:
		'''
		java -jar -Xmx40g resources/sicelore-2.1/Jar/NanoporeBC_UMI_finder-2.1.jar scanfastq \
			-d {params.in_folder} \
			-o {params.out_folder} \
			--bcEditDistance 1 \
			-g {params.in_barcodes} \
			-t {threads}
		'''
	
rule sicelore_scanfastq_ill_v210_bis:
	input:
		rules.cellranger_count_v710_bis.output,
		'evaluation/data/scmixology2_data/nanopore/ERR9958136/LR_sc-RNA-seq_SCMIXOLOGY2_pass.fastq.gz',
	output:
		'evaluation/results/scmixology2_data/sicelore/ERR9958136/umifinder_ill/BarcodesAssigned.tsv'
	threads:
		config['scmixology2_data']['threads']
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	params:
		in_barcodes='evaluation/results/scmixology2_data/cellranger/SRR12282462/outs/raw_feature_bc_matrix/barcodes.tsv.gz',
		in_folder='evaluation/data/scmixology2_data/nanopore/ERR9958136',
		out_folder='evaluation/results/scmixology2_data/sicelore/ERR9958136/umifinder_ill'
	container:
		'docker://edg1983/sicelore:v2.1'
	shell:
		'''
		java -jar -Xmx40g resources/sicelore-2.1/Jar/NanoporeBC_UMI_finder-2.1.jar scanfastq \
			-d {params.in_folder} \
			-o {params.out_folder} \
			--bcEditDistance 1 \
			-g {params.in_barcodes} \
			-t {threads}
		'''

rule sicelore_sicelore_noill_v210_bis:
	input:
		rules.sicelore_scanfastq_noill_v210_bis.output
	output:
		'evaluation/results/scmixology2_data/sicelore/ERR9958136/sicelore_noill/barcodes.csv'
	threads:
		1
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	container:
		'docker://edg1983/sicelore:v2.1'
	shell:
		'''
		java -jar -Xmx40g resources/sicelore-2.1/Jar/Sicelore-2.1.jar SelectValidCellBarcode \
		-I {input} \
		-O {output} \
		-MINUMI 500 \
		-ED0ED1RATIO 1
		'''

rule sicelore_sicelore_ill_v210_bis:
	input:
		rules.sicelore_scanfastq_ill_v210_bis.output
	output:
		'evaluation/results/scmixology2_data/sicelore/ERR9958136/sicelore_ill/barcodes.csv'
	threads:
		1
	resources:
		mem_mb=config['scmixology2_data']['mem'],
		time=config['scmixology2_data']['time']
	container:
		'docker://edg1983/sicelore:v2.1'
	shell:
		'''
		java -jar -Xmx40g resources/sicelore-2.1/Jar/Sicelore-2.1.jar SelectValidCellBarcode \
		-I {input} \
		-O {output} \
		-MINUMI 500 \
		-ED0ED1RATIO 1
		'''

rule knee_data_blaze_bis:
	input:
		rules.blaze_v110_bis.output
	output:
		'evaluation/results/scmixology2_data/blaze/ERR9958136/bcs.tsv'
	threads:
		1
	shell:
		'''
		./workflow/scripts/blaze_bcs.sh evaluation/results/scmixology2_data/blaze/ERR9958136
		'''

rule knee_data_cellranger_bis:
	input:
		rules.cellranger_count_v710_bis.output
	output:
		'evaluation/results/scmixology2_data/cellranger/SRR12282462/outs/bcs.tsv'
	threads:
		1
	container:
		'docker://davidebolo1993/wf-single-cell:latest'
	shell:
		'''
		./workflow/scripts/cellranger_bcs.sh evaluation/results/scmixology2_data/cellranger/SRR12282462/outs
		'''

rule knee_data_wf_single_cell_bis:
	input:
		rules.wf_single_cell_v020_bis.output
	output:
		'evaluation/results/scmixology2_data/wf-single-cell/ERR9958136/ERR9958136/bcs.tsv'
	threads:
		1
	container:
		'docker://davidebolo1993/wf-single-cell:latest'
	shell:
		'''
		./workflow/scripts/wf-single-cell_bcs.sh evaluation/results/scmixology2_data/wf-single-cell/ERR9958136/ERR9958136
		'''

rule knee_data_scnanogps_bis:
	input:
		rules.scnanogps_assigner_v100_bis.output
	output:
		'evaluation/results/scmixology2_data/scnanogps/ERR9958136/assigner/bcs.tsv'
	threads:
		1
	container:
		'docker://davidebolo1993/wf-single-cell:latest'
	shell:
		'''
		./workflow/scripts/scnanogps_bcs.sh evaluation/results/scmixology2_data/scnanogps/ERR9958136/assigner
		'''

rule knee_data_sicelore_bis:
	input:
		rules.sicelore_sicelore_ill_v210_bis.output,
		rules.sicelore_sicelore_noill_v210_bis.output
	output:
		'evaluation/results/scmixology2_data/sicelore/ERR9958136/bcs.tsv'
	threads:
		1
	shell:
		'''
		./workflow/scripts/sicelore_bcs.sh evaluation/results/scmixology2_data/sicelore/ERR9958136
		'''

rule combine_knee_data_bis:
	input:
		rules.knee_data_blaze_bis.output, rules.knee_data_cellranger_bis.output, rules.knee_data_wf_single_cell_bis.output, rules.knee_data_scnanogps_bis.output, rules.knee_data_sicelore_bis.output
	output:
		'evaluation/results/scmixology2_data/bcs.tsv'
	threads:
		1
	shell:
		'''
		cat {input} > {output}
		'''

rule plot_knee_data_bis:
	input:
		rules.combine_knee_data_bis.output
	output:
		'evaluation/results/scmixology2_data/evaluation.pdf'
	threads:
		1
	conda:
		'../envs/r-env.yml'
	shell:
		'''
		Rscript workflow/scripts/plotevaluation.r {input} {output}
		'''

