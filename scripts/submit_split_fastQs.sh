#!/usr/bin/env bash

###A cluster script to be submitted to via qsub that will trim and align reads

#First we give a few cluster parameters

# Define the expected running time of your job. Hopefully nothing runs longer than this
#$ -l h_rt=72:00:00

# Specify cue via expected length of job. Is there a reason to ever use anything other than medium?
#$ -P medium

# Combine stderr and stdout log files into the stdout log file.
#$ -j y

# Keep current environment variables.
#$ -V

# Use current working directory as working directory of the job.
#$ -cwd

# And specify the number of cores we want for this job
#$ -pe smp 31

# Set the log directory.
#$ -o logs

SCRIPT1=$1
SCRIPT2=$2
TYPEDATA=$3
R1=$4
R2=$5 # This line is not necessary for single end reads
FILESTOSPLIT=$6
OUTDIR=$7 ## Must be directory as the one where the files are stored.

source activate SplitFastQ

perl $SCRIPT1 $SCRIPT2 $TYPEDATA $R1 $R2 $FILESTOSPLIT $OUTDIR

conda deactivate

##---------------------------------------------------------- Notes: -----------------------------------------------------------------------------------------##
# Before to run the split process, create and activate the environtment, and install the option to run in parallel using "cpanm Proc::Queue" in the terminal  #
# SCRIPT1 and SCRIPT2 are found in /fast/groups/ag_garfield/work/projects/6_sc_pipeline_development/atac_pipeline_scripts/helper_scripts/ATAC_fastq_splitter. #
# SCRIPT1= path to parsing script (split_fastq_sciATAC.pl)                                                                                                    #
# SCRIPT2 = path to filtering script (filteringIDsFastQs.pl). Same directory as SCRIPT1                                                                       #
# TYPEDATA: paired or single                                                                                                                                  #
# R1 = Path to R1_fastq                                                                                                                                       #
# R2 = Path to R2_fastq	                                                                                                                                      #
# FILESTOSPLIT = Total numer of files to produce as OUTPUTS                                                                                                   #
# OUTDIR = Path to final output                                                                                                                               #
##-----------------------------------------------------------------------------------------------------------------------------------------------------------##
