# split_fastQ
The code in this repository is of use for splitting fastq files. This script was intially created to split fatq files from single cell sequencing based on the barcodes for cell, and it is now of use for any fastq where the read identifiers follow the format: `@M00947:416:000000000-CJPJP:1:1101:15361:1341 1:N:0:9`. Notice that the space is of use for the splitting step. If different format, perhaps you would like to adjust the lines 35, 37, and 44 (paired end), or 58 and 63 (single end) in the split_fastq.pl script.

To be able to run the code from this repository, you will need:
1. Create the environment using the split_fastq.yml file: conda env create -f split_fastq.yml. It will create a conda environment called splitFastq (Recommended step). The user can also install the required programs on its local file system using the listed programs in the yml file as guide.

2. Install the Proc::Queue perl module within the CovSnp environment using `cpanm Proc::Queue`. This is of use running it in parallel.

3. Adjust the number of cores the script will use (line 8, split_fastq.pl). Currently set to 31 cores.

`Helper notes`
To run the script you will need to indicate:
	1. path to the parsing script split_fastq.pl
	2. path to filtering script filteringIDsFastQs.pl
	3. type of data:
  	either "paired" or "single"
 	4. fastq1 (only one for single end reads)
 	5. fastq2
 	6. number of files to split the fatsq files into (integer)
 	7. Output directory. It can be the same of the fastq files


`Examples:
	# Paired end (of use for data sample available in the test folder):
	perl ../scripts/split_fastq.pl ../scripts/filteringIDsFastQs.pl paired L001_R1_001.fastq.gz L001_R2_001.fastq.gz 3 splitted_fastq

	# Single end:
	perl ../scripts/split_fastq.pl ../scripts/filteringIDsFastQs.pl single L001_R1_001.fastq.gz 3 splitted_fastq
Note: OUTDIR corresponds to the directory where the split fastq files will be saved.`

`These some are the possible solutions to common issues when using the split_fastq.pl`
	1. Have you created the environment splitFastq using split_fastq.yml
	2. Is the extra module from the cpan: cpanm Proc::Queue already installed? If not,  activate the splitFastq environment and run the piece of code mentioned above?
	3. If you are using the submission script, is it already set with variables to be submitted?
		"submit_split_fastQs.sh":
	        qsub submit_split_fastQs.sh $SCRIPT1 $SCRIPT2 $TYPEDATA $R1 $R2 $FILESTOSPLIT $OUTDIR
	   WHERE:
	   SCRIPT1=/path/to/script/split_fastq_sciATAC.pl
	   SCRIPT2=/path/to/script/filteringIDsFastQs.pl
	   TYPEDATA=paired
	   R1=/path/to/fastqs/file1.fastq.gz
	   R2=/path/to/fastqs/file2.fastq.gz
	   FILESTOSPLIT=integer
	   OUTDIR=/path/to/fastqs/
	4. Perhaps your fastq files are named as *gz, but they are not in TRUE gzip format.
	5. Perhaps your fastq files do not follow the format described above. Have a look of the example files in the test directory.
	6. If none of these suggestions helped you out, I'b be happy to help.
