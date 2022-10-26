import pandas as pd
import os
import sys
from glob import glob
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

		y=glob(os.path.abspath(x) + "/" + index + "*") #retrive file with id
		resources=os.path.abspath(base + '/resources/fastq/illumina/' + index)
		
		if not os.path.exists(resources):

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

		y=glob(os.path.abspath(x) + "/" + index + "*") #retrive file with id
		resources=os.path.abspath(base + '/resources/fastq/nanopore/' + index)
		
		if not os.path.exists(resources):

			for fq in y: #create symbolik links

				if not os.path.exists(os.path.abspath(resources + '/' + os.path.basename(fq))):

					target=os.path.abspath(resources + '/' + os.path.basename(fq))
					os.symlink(os.path.abspath(fq), target)

	return df_,True


def organize_samplesheet_and_resources(df):

	'''
	Create sample sheet, as described in https://github.com/epi2me-labs/wf-single-cell
	'''
	
	base=os.path.dirname(os.path.abspath(os.path.dirname(config['samples'])))
	resources=os.path.abspath(base + '/resources/single-cell-sample-sheet')
	os.makedirs(resources, exist_ok=True)
	write_sheet='sample_id,kit_name,kit_version,exp_cells\n'
	c=0
	
	for index,row in df.iterrows():

		if config['wf-single-cell']['kit'].split(',')[c] == '5prime':

			if config['wf-single-cell']['version'].split(',')[c] not in ['v1', 'v2']:

				now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
				print('[' + now + ']' + '[Error] Wrong kit version in wf-single-cell configuration. Can be either v1 or v2.')
				sys.exit(1)
			
		elif config['wf-single-cell']['kit'].split(',')[c] == '3prime':

			if config['wf-single-cell']['version'].split(',')[c] not in ['v2', 'v3']:

				now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
				print('[' + now + ']' + '[Error] Wrong kit version in wf-single-cell configuration. Can be either v2 or v3.')
				sys.exit(1)

		else:

			now=datetime.now().strftime('%d/%m/%Y %H:%M:%S')
			print('[' + now + ']' + '[Error] Wrong kit name in wf-single-cell configuration. Can be either ')
			sys.exit(1)

		write_sheet+=index + ',' + config['wf-single-cell']['kit'].split(',')[c] + ',' + config['wf-single-cell']['version'].split(',')[c] + ',' + (str(500) if str(config['wf-single-cell']['expect_cells']).split(',')[c] == '' else str(config['wf-single-cell']['expect_cells']).split(',')[c]) + '\n'
		sample_sheet=os.path.abspath(resources + '/' + index + '.single_cell_sample_sheet.csv')
		
		with open (sample_sheet, 'w') as sheet_out:
			
			sheet_out.write(write_sheet)

		#re-initialize if we have another sample
		write_sheet='sample_id,kit_name,kit_version,exp_cells\n'
		c+=1

	resources=os.path.abspath(base + '/resources/single-cell-resources')
	os.makedirs(resources, exist_ok=True)
	config_sheet=os.path.abspath(resources + '/wf-single-cell.config')

	write_sheet='executor {\n\t$local {\n\t\tcpus = ' + str(config['wf-single-cell']['threads']) + '\n\t\tmemory = "' +  str(int(config['wf-single-cell']['mem']/1024)) + 'GB"\n\t}\n}\n'

	with open (config_sheet, 'w') as sheet_out:
			
		sheet_out.write(write_sheet)


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
	os.makedirs(resources,exist_ok=True)
	target=os.path.basename(config['reference'])

	if not os.path.exists(os.path.abspath(resources + '/' + target)):
	
		os.symlink(config['reference'], os.path.abspath(resources + '/' + target))
