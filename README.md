# split_fastq
The code in this repository is of use for splitting fastq files. This script was intially created to split fatq files from single cell sequencing based on the barcodes for cell, and it is now of use for any fastq file where the identifiers for reads follow the format: `@M00947:416:000000000-CJPJP:1:1101:15361:1341 1:N:0:9`. Notice that the space ' ' is of use for the splitting step. If your fastq files follow a different format, perhaps you would like to explore and adjust adjust the lines 35, 37, and 44 (paired end), or 58 and 63 (single end) in the split_fastq.pl script.

To be able to run the code from this repository, you will need:

1. to create the environment using the split_fastq.yml file: `conda env create -f split_fastq.yml`. It will create a conda environment called splitFastq (Recommended step). The user can also install the required programs on its local file system using the listed programs in the yml file as guide.

2. To install the Proc::Queue perl module within the CovSnp environment using `cpanm Proc::Queue`. This is a required step, and it is of use for running split_fastq in parallel.

3. Adjust the number of cores the script will use (line 8, split_fastq.pl). Currently set to 31 cores.

### Helper notes

To run the script you will need to indicate:
	1. path to the parsing script: split_fastq.pl
	2. path to filtering script: filteringIDsFastQs.pl
	3. type of data: either "paired" or "single" end reads
 	4. fastq_1 (only one for single end reads)
 	5. fastq_2
 	6. number of files to split the fastq files (integer)
 	7. Output directory.

### Examples:
<br>

### Paired end (of use for data sample available in the test folder):
<br>
` perl ../scripts/split_fastq.pl ../scripts/filteringIDsFastQs.pl paired L001_R1_001.fastq.gz L001_R2_001.fastq.gz 3 splitted_fastq `
<br>
<br>

### Single end:
<br>
` perl ../scripts/split_fastq.pl ../scripts/filteringIDsFastQs.pl single L001_R1_001.fastq.gz 3 splitted_fastq `
<br>
<br>

### Note:
OUTDIR corresponds to the directory where the split fastq files will be saved.`
<br>


### These some are the possible solutions to common issues when using the split_fastq.pl`

	1. Does the splitFastq environment already exist in your machine?

	2. Is the extra module from the cpan: cpanm Proc::Queue already installed? If not,  activate the splitFastq environment and run the piece of code mentioned above?

	3. If you are using the submission script, is it already set with variables to be submitted?
		"submit_split_fastQs.sh":

	        qsub submit_split_fastQs.sh $SCRIPT1 $SCRIPT2 $TYPEDATA $R1 $R2 $FILESTOSPLIT $OUTDIR

	   Where:
	   - SCRIPT1=/path/to/script/split_fastq_sciATAC.pl

	   - SCRIPT2=/path/to/script/filteringIDsFastQs.pl

	   - TYPEDATA=paired

	   - R1=/path/to/fastqs/file1.fastq.gz

	   - R2=/path/to/fastqs/file2.fastq.gz

	   - FILESTOSPLIT=integer

	   - OUTDIR=/path/to/fastqs/

	4. Perhaps your fastq files are named as *gz, but they are not in TRUE gzip format. They must be in gz format.

	5. Perhaps your fastq files do not follow the format described above. Have a look of the example files in the test directory.

	6. If none of these suggestions helped you out, let me know, I would be happy to help you.
