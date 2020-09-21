# split_fastQ

The code in this repository is of use for splitting fastq files
`Helper notes`
# To run the script you will need to indicate:                     #
# 1. path to the parsing script split_fastq_sciATAC.pl             #
# 2. path to filtering script filteringScript.pl                   #
# 3. type of data:                                                 #
#    either "paired" or "single"                                   #
# 4. fastq1 (only one for single end reads)                        #
# 5. fastq2                                                        #
# 6. number of files to split the fatsq files into                 #
# 7. Output directory. It can be the same of the fastq files       #
#                                                                  #
# This script is meant to be used for splitting fastq              #
# files (sciATAC seq data) in which the barcodes were              #
# already corrected.                                               #
#                                                                  #
# use 1:                                                           #
# Paired: perl script.pl filteringScript.pl paired R1 R2 # OUTDIR  #
# use 2:                                                           #
# usage 2. perl script.pl filteringScript.pl single R1 # OUTDIR.   #
##----------------------------------------------------------------##


## These some are the likely explanations why the split_fastq_sciATAC.pl is not working
	1. Have you created the environment SplitFastQ using SplitFastQ.yml
	2. Have you installed the extra module from the cpan by using cpanm Proc::Queue after installing the environment SplitFastQ
	3.Have you defined the right input input for the submission script "submit_split_fastQs.sh":
	        qsub submit_split_fastQs.sh $SCRIPT1 $SCRIPT2 $TYPEDATA $R1 $R2 $FILESTOSPLIT $OUTDIR
	   WHERE:
	   SCRIPT1=/path/to/script/split_fastq_sciATAC.pl
	   SCRIPT2=/path/to/script/filteringIDsFastQs.pl
	   TYPEDATA=paired
	   R1=/path/to/fastqs/file1.fastq.gz
	   R2=/path/to/fastqs/file2.fastq.gz
	   FILESTOSPLIT=10
	   OUTDIR=/path/to/fastqs/
	4. Perhaps your fastq files are named as *gz, but they are not in TRUE gzip format.
	5. Perhaps your fastq files do not follow this format. For instance, have spaces where they should not be, read name does not end in 1 or 2
		@NS500648.21 CGCTCAGGCTGTCGGTCCGGCAATTACTNNNATAGG:21/2
		GCCCATTTCCATCAATCCAGGACGAAGTAGAGAATCAATGGAAGGATTGGCAGCAAGTGCGTTATAGCAAACAAAACAGCACATTTATCAAAGAGAGGAGCGGAATTATT
		+
		A/<AA6//EE6EA//AA//EA/AEA<AA///E//E<</6A/////AE/<E///A/A/6A/////A////A/6///E<E/<///A/A/<A/<//E/<</////A//<E6//
	6. If none of these suggestions took your trough running this step, let me know
