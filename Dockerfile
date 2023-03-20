FROM ubuntu:20.04
LABEL description="wf-single-cell"
LABEL base_image="ubuntu:latest"
LABEL software="wf-single-cell"
LABEL about.home="https://github.com/davidebolo1993/smk_sc_lr"
LABEL about.license="GPLv3"
ARG DEBIAN_FRONTEND=noninteractive
#install basic libraries and python

WORKDIR /opt

RUN apt-get update
RUN apt-get -y install build-essential \
	wget git \
	bzip2 libbz2-dev \
	zlib1g zlib1g-dev \
	liblzma-dev \
	libssl-dev \
	libncurses5-dev \
	libz-dev \
	python3-distutils python3-dev python3-pip \ 
	libjemalloc-dev \
	cmake make g++ \
	libhts-dev \
	libzstd-dev \
	autoconf \
	libatomic-ops-dev \
	pkg-config \
	pigz \
	bc \
	gawk \
	openjdk-11-jdk \
	&& apt-get -y clean all \
	&& rm -rf /var/cache

#python3 to python

RUN ln -s /usr/bin/python3 /usr/bin/python

##install nextflow all to work offline

RUN mkdir -p nextflow_bin \
	&& cd nextflow_bin \
	&& wget https://github.com/nextflow-io/nextflow/releases/download/v22.10.1/nextflow-22.10.1-all \
	&& chmod 755 nextflow-22.10.1-all \
	&& mv nextflow-22.10.1-all nextflow

ENV PATH /opt/nextflow_bin:$PATH
	
##install samtools

RUN wget https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2 \
	&& tar -jxvf samtools-1.16.1.tar.bz2 \
	&& rm samtools-1.16.1.tar.bz2 \
	&& cd samtools-1.16.1 \
	&& ./configure \
	&& make \
	&& make install

##install minimap2/mm2-fast, paftools js and k8 - required by paftools js

RUN wget https://github.com/lh3/minimap2/releases/download/v2.24/minimap2-2.24_x64-linux.tar.bz2 \
	&& tar -xjvf minimap2-2.24_x64-linux.tar.bz2 \
	&& rm minimap2-2.24_x64-linux.tar.bz2

ENV PATH /opt/minimap2-2.24_x64-linux:$PATH

##install seqkit

RUN mkdir -p seqkit \
	&& cd seqkit \
	&& wget https://github.com/shenwei356/seqkit/releases/download/v2.3.1/seqkit_linux_386.tar.gz \
	&& tar -xvzf seqkit_linux_386.tar.gz \
	&& rm seqkit_linux_386.tar.gz

ENV PATH /opt/seqkit:$PATH

##install bedtools

RUN mkdir -p bedtools \
	&& cd bedtools \
	&& wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools.static.binary \
	&& mv bedtools.static.binary bedtools \
	&& chmod a+x bedtools

ENV PATH /opt/bedtools:$PATH

##install fastcat

RUN wget https://github.com/epi2me-labs/fastcat/archive/refs/tags/v0.4.12.tar.gz \
	&& tar -xvzf v0.4.12.tar.gz \
	&& rm v0.4.12.tar.gz \
	&& cd fastcat-0.4.12 \
	&& make fastcat

ENV PATH /opt/fastcat-0.4.12:$PATH

##install vsearch

RUN mkdir -p vsearch \
	&& cd vsearch \
	&& wget https://github.com/torognes/vsearch/releases/download/v2.22.1/vsearch-2.22.1-linux-x86_64-static.tar.gz \
	&& tar -xvzf vsearch-2.22.1-linux-x86_64-static.tar.gz \
	&& rm vsearch-2.22.1-linux-x86_64-static.tar.gz

ENV PATH /opt/vsearch/vsearch-2.22.1-linux-x86_64-static/bin:$PATH

##install salmon (1.9.0)

#RUN wget https://github.com/COMBINE-lab/salmon/releases/download/v1.9.0/salmon-1.9.0_linux_x86_64.tar.gz \
#	&& tar -xvzf salmon-1.9.0_linux_x86_64.tar.gz \
#	&& rm salmon-1.9.0_linux_x86_64.tar.gz

#ENV PATH /opt/salmon-1.9.0_linux_x86_64/bin:$PATH

##install stringtie

RUN wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-2.2.1.Linux_x86_64.tar.gz \
	&& tar -xvzf stringtie-2.2.1.Linux_x86_64.tar.gz \
	&& rm stringtie-2.2.1.Linux_x86_64.tar.gz

ENV PATH /opt/stringtie-2.2.1.Linux_x86_64:$PATH

##install gffread

RUN wget http://ccb.jhu.edu/software/stringtie/dl/gffread-0.12.7.Linux_x86_64.tar.gz \
	&& tar -xvzf gffread-0.12.7.Linux_x86_64.tar.gz \
	&& rm gffread-0.12.7.Linux_x86_64.tar.gz

ENV PATH /opt/gffread-0.12.7.Linux_x86_64:$PATH

##install gffcompare

RUN wget http://ccb.jhu.edu/software/stringtie/dl/gffcompare-0.12.6.Linux_x86_64.tar.gz \
	&& tar -xvzf gffcompare-0.12.6.Linux_x86_64.tar.gz \
	&& rm gffcompare-0.12.6.Linux_x86_64.tar.gz

ENV PATH /opt/gffcompare-0.12.6.Linux_x86_64:$PATH

##install additional python3 modules

RUN pip3 install pandas \
	numpy==1.23.5 \
	scipy \
	tqdm \
	pysam \
	editdistance \
	parasail==1.2.3 \
	bioframe==0.3.2 \
	matplotlib \
	scikit-learn \
	biopython \
	umap-learn==0.5.2 \
	flake8 \
	dominate \
	ezcharts \
	umi_tools \
	rapidfuzz
