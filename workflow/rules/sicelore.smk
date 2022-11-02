#dismissed for the time being - I will focus on wf-single-cell for the time being

# rule junctions:
#     input:
#        config['reference'] + '/genes/genes.gtf'
#     output:
#         'resources/sicelore/junctions.bed'
#     threads: 
#         1
#     conda:
#         '../envs/sicelore.yaml'
#     shell:
#         '''
#         paftools.js gff2bed -j {input} > {output}
#         '''    

# rule refflat:
#     input:
#         config['reference'] + '/genes/genes.gtf'
#     output:
#         'resources/sicelore/refflat.txt'
#     threads: 
#         1
#     conda:
#         '../envs/sicelore.yaml'
#     params:
#         out_tmp='resources/sicelore/refflat.tmp.txt'
#     shell:
#         '''
#         gtfToGenePred -genePredExt -geneNameAsName2 {input} {params.out_tmp} \
#         && paste <(cut -f 12 {params.out_tmp}) <(cut -f 1-10 {params.out_tmp} > {output} \
#         && rm {params.out_tmp}
#         '''

# rule decompress_barcodes:
#     input:
#         rules.cellranger_count.output
#     output:
#         'results/ill_ont/sicelore/illumina_parser/{sample}.barcodes.tsv'
#     threads:
#         1
#     params:
#         bc='results/ill_ont/sicelore/cellranger/{sample}/outs/filtered_feature_bc_matrix/barcodes.tsv.gz'
#     shell:
#         '''
#         zcat {params.bc} > {output}
#         '''

# rule illumina_parser:
#     input:
#         bam=rules.cellranger_count.output.bam,
#         bc=rules.decompress_barcodes.output
#     output:
#        'results/ill_ont/sicelore/illumina_parser/{sample}.illumina.bam.obj',
#     threads:
#         config['sicelore']['threads']
# 	resources:
# 		mem_mb=config['sicelore']['mem'],
# 		time=config['sicelore']['time']
#     conda:
#         '../envs/sicelore.yaml'
#     shell:
#         '''
#         java -jar -Xmx100g -XX:-UseGCOverheadLimit -XX:+UseConcMarkSweepGC \
#             resouces/sicelore/Jar/IlluminaParser-1.0.jar \
#             -i {input.bam} \
#             -o {output} \
#             -t {input.bc} \
#             -b CB \
#             -g GN \
#             -u UB
#         '''

