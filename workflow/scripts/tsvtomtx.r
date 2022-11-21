#!/usr/bin/env Rscript

library(Matrix)
library(optparse)
sessionInfo()

writeMMgz <- function(x, file) {
	mtype <- "real"
	if (is(x, "ngCMatrix")) {
		mtype <- "integer"
	}
	zz<-gzfile(file,"w")
	writeLines(
		c(
			sprintf("%%%%MatrixMarket matrix coordinate %s general", mtype),
			sprintf("%s %s %s", x@Dim[1], x@Dim[2], length(x@x))
		),
		zz
	)
	close(zz)
	data.table::fwrite(
		x = summary(x),
		file = file,
		append = TRUE,
		sep = " ",
		row.names = FALSE,
		col.names = FALSE
	)
}

writeGzFile <- function(x,file){
	data.table::fwrite(
		x = x,
		file = file,
		sep = "\t",
		row.names = FALSE,
		col.names = FALSE
	)
}

options(warn = -1)

option_list = list(
  make_option(c('-c', '--counts'), action='store', type='character', help='gene/transcript counts .tsv'),
	make_option(c('-g', '--gtf'), action='store', type='character', help='gene model in .gtf format'),
	make_option(c('-o', '--output'), action='store', type='character', help='output directory'),
        make_option(c('-t', '--transcript'), action='store_true', default=FALSE, help='use transcript matrix instead of gene matrix'),
	make_option(c('-b', '--biotype'), action='store_true', default=FALSE, help='additionally store a features-like file with biotypes')
)

opt = parse_args(OptionParser(option_list=option_list))

print(opt)

# create directory
dir.create(file.path(opt$output), showWarning=F)

# generate single-cell RNA seq data
now<-Sys.time()
message('[',now,'][Message] reading gene/transcript x cell .tsv') 

gbm<-as.matrix(data.table::fread(file.path(opt$counts)),header=T,rownames=1)

now<-Sys.time()
message('[',now,'][Message] done')
message('[',now,'][Message] converting to sparse matrix')

# save sparse matrix
sparse.gbm <- Matrix(gbm,sparse = T)

now<-Sys.time()
message('[',now,'][Message] done')
message('[',now,'][Message] storing to file')
## Market Exchange Format (MEX) format
writeMMgz(x=sparse.gbm, file=file.path(opt$output,"matrix.mtx.gz"))

now<-Sys.time()
message('[',now,'][Message] done')
message('[',now,'][Message] loading gene model')


#load gene model - gtf
gtf<-rtracklayer::import(file.path(opt$gtf))
gtf_df<-data.table::as.data.table(gtf)

now<-Sys.time()
message('[',now,'][Message] done')

#maybe there are better ways - but this is pretty fast

if (!opt$transcript) {

	#we have name -> we get id
	message('[',now,'][Message] translating gene names to ensembl gene ids')
	vals<-do.call(c,lapply(rownames(gbm),function(x) {unique(gtf_df[gene_name == x]$gene_id)[1]}))
	now<-Sys.time()
	message('[',now,'][Message] done')
	message('[',now,'][Message] storing to file')

	writeGzFile(x = data.frame(V1=rownames(gbm),V2=vals, V3="Gene Expression"), file =file.path(opt$output,"features.tsv.gz"))

	if (opt$biotype) {

		now<-Sys.time()
		message('[',now,'][Message] extracting biotypes')
		bios<-do.call(c,lapply(rownames(gbm),function(x) {unique(gtf_df[gene_name == x]$gene_type)[1]}))
                now<-Sys.time()
                message('[',now,'][Message] done')
                message('[',now,'][Message] storing to file')		
		writeGzFile(x = data.frame(V1=rownames(gbm),V2=vals, V3=bios), file =file.path(opt$output,"biotypes.tsv.gz"))
	}


} else {

	#we have id-> we get name
	message('[',now,'][Message] translating transcript ids to ensembl transcript names')
	vals<-do.call(c,lapply(rownames(gbm),function(x) {unique(gtf_df[transcript_id == x]$transcript_name)[1]}))	

	now<-Sys.time()
	message('[',now,'][Message] done')
	message('[',now,'][Message] storing to file')

	writeGzFile(x = data.frame(V1=vals,V2=rownames(gbm), V3="Gene Expression"), file =file.path(opt$output,"features.tsv.gz"))

        if (opt$biotype) {

                now<-Sys.time()
                message('[',now,'][Message] extracting biotypes')
                bios<-do.call(c,lapply(rownames(gbm),function(x) {unique(gtf_df[transcript_id == x]$transcript_type)[1]}))
                now<-Sys.time()
                message('[',now,'][Message] done')
                message('[',now,'][Message] storing to file')
                writeGzFile(x = data.frame(V1=vals,V2=rownames(gbm), V3=bios), file =file.path(opt$output,"biotypes.tsv.gz"))
        }



}

now<-Sys.time()
message('[',now,'][Message] done')
message('[',now,'][Message] storing cell barcodes to file')

#barcodes
writeGzFile(x = data.frame(V1=paste0(colnames(gbm), "-1")), file=file.path(opt$output,"barcodes.tsv.gz"))

now<-Sys.time()
message('[',now,'][Message] done')
