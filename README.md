# split_fastQ

## These some are the likley explanations why the split_fastq_sciATAC.pl is not working
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
