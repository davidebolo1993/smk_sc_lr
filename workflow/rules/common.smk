import pandas as pd
import os
import sys
import glob
from datetime import datetime

def organizer_illumina():

	'''
	Organize input-output for better usage of Snakemake rules - Illumina
	'''

	#samples

	if not os.path.exists(config['samples']):

		now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
		print('[' + now + ']' + '[Error] Input sample table does not exist')
		sys.exit(1)
	
	base=os.path.dirname(os.path.abspath(os.path.dirname(config['samples'])))

	try:

		df=(pd.read_table(config['samples'], dtype={"sample_id": str, "sample_fastq_dir":str, "sample_type":str})
		.set_index("sample_id", drop=False)
		.sort_index()
		)

	except:

		now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
		print('[' + now + ']' + '[Error] Incorrect format of the input sample table')
		sys.exit(1)


	df_=df[(df == 'ILL').any(axis=1)]

	if df_.shape[0] == 0:

		#just the header, no ILL data
		return df_, False

	for index, row in df_.iterrows():

		x=row['sample_fastq_dir']
		
		if not os.path.exists(os.path.abspath(x)):

			now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
			print('[' + now + ']' + '[Error] Directory ' + os.path.abspath(x) + '  does not exist')
			sys.exit(1)

		y=glob.glob(os.path.abspath(x) + "/" + index + "*") #retrive file with id
		resources=os.path.abspath(base + '/resources/fastq/illumina/' + index)
		os.makedirs(resources, exist_ok=True)

		for fq in y: #create symbolik links

			if not os.path.exists(os.path.abspath(resources + '/' + os.path.basename(fq))):

				target=os.path.abspath(resources + '/' + os.path.basename(fq))
				os.symlink(os.path.abspath(fq), target)

	return df_,True

def organizer_nanopore():

	'''
	Organize input-output for better usage of Snakemake rules - ONT
	'''

	#samples

	if not os.path.exists(config['samples']):

		now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
		print('[' + now + ']' + '[Error] Input sample table does not exist')
		sys.exit(1)
	
	base=os.path.dirname(os.path.abspath(os.path.dirname(config['samples'])))

	try:

		df=(pd.read_table(config['samples'], dtype={"sample_id": str, "sample_fastq_dir":str, "sample_type":str})
		.set_index("sample_id", drop=False)
		.sort_index()
		)

	except:

		now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
		print('[' + now + ']' + '[Error] Incorrect format of the input sample table')
		sys.exit(1)


	df_=df[(df == 'ONT').any(axis=1)]


	if df_.shape[0] == 0:

		#just the header, no ONT data
		return df_, False

	for index, row in df_.iterrows():

		x=row['sample_fastq_dir']
		
		if not os.path.exists(os.path.abspath(x)):

			now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
			print('[' + now + ']' + '[Error] Directory ' + os.path.abspath(x) + '  does not exist')
			sys.exit(1)

		y=glob.glob(os.path.abspath(x) + "/" + index + "*") #retrive file with id
		resources=os.path.abspath(base + '/resources/fastq/nanopore/' + index)
		os.makedirs(resources, exist_ok=True)

		for fq in y: #create symbolik links

			if not os.path.exists(os.path.abspath(resources + '/' + os.path.basename(fq))):

				target=os.path.abspath(resources + '/' + os.path.basename(fq))
				os.symlink(os.path.abspath(fq), target)

	return df_,True

def organizer_reference():

	'''
	Create symlink to reference folder - it assumes a reference from 10X genomics and its folder structure
	'''

	if not os.path.exists(config['reference']):

		now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
		print('[' + now + ']' + '[Error] Input reference directory does not exist')
		sys.exit(1)

	base=os.path.dirname(os.path.abspath(os.path.dirname(config['samples'])))
	resources=os.path.abspath(base + '/resources/reference')
	os.makedirs(resources, exist_ok=True)
	target=os.path.basename(config['reference'])

	if not os.path.exists(target):
	
		os.symlink(config['reference'], os.path.abspath(resources + '/' + target))
