#usr/bin/perl
##------------------------scATAC-seq Analysis---------------------##
## Alvaro Perdomo-Sabogal                                         ##
## Garfieldlab, HU, 2019                                          ## 
##                                                                ##
##------------------------ HELPER NOTES---------------------------##
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
use strict;
use warnings"all";
use DirHandle;
use Data::Dumper;
use Cwd qw(getcwd);
use File::Temp qw/ tempfile tempdir /;
use Proc::Queue size=>31, qw(run_back);
Proc::Queue::trace(1); ## Note: if this package does not work in your conda environment use this command to install it via terminal: cpanm Proc::Queue

# Read argument [0] in the command line, type of data, single or paired end
my $filteringScript=$ARGV[0];
my $typeData = $ARGV[1];
my $pair1;
my $pair2;
my $numberOffastqs;
my $dir;
my $datestring = localtime();
  print("Starting time one = $datestring\n"); 

## Loop for pair en reads 
if ($typeData eq "paired") {
  $pair1 = $ARGV[2];
    print("$pair1\n");
  $pair2 = $ARGV[3];
    print("$pair2\n");
  $numberOffastqs = $ARGV[4]; 
  $dir=$ARGV[5];
  system("unpigz --best -p 15 -k $pair1");
  system("unpigz --best -p 15 -k $pair2");
  $pair1 =~s/.gz//;
  $pair2 =~s/.gz//;
  $pair1 =~s/^.*\///;
  $pair2 =~s/^.*\///;
  system("mv $pair1 $dir");
  system("mv $pair2 $dir");
  system("perl -p -e 's/\n+/ /' $dir/$pair1 | perl -p -e 's/@/\n@/g' | sed '/^\$/d' > $dir/$pair1.'2'");
  print ("PAIR1 $pair1\n");
  system("perl -p -e 's/\n+/ /' $dir/$pair2 | perl -p -e 's/@/\n@/g' | sed '/^\$/d' > $dir/$pair2.'2'");
  print ("PAIR2 $pair1\n");
  $pair1 = $pair1.'.2'; 
  $pair2 = $pair2.'.2';

  #Getting the identifiers 'barcodes' per Cell and the header
  if (-e "$dir/$pair1.'.IDs'") {
      my $identifiers =  $dir/$pair1.'.IDs';
    } else {
      my $identifiers = "sed 's/\:.*//g;' $dir/$pair1 | sort | uniq > $dir/$pair1.'IDs'";
      system ($identifiers);
  }
}

# Loop for single end reads
if ($typeData eq "single") {
  $pair1 = $ARGV[2];
  $numberOffastqs = $ARGV[3]; 
  $dir=$ARGV[4];
    print("$pair1\n");
  system("unpigz --best -p 10 -k $pair1");
  $pair1 =~s/.gz//;
  $pair1 =~s/^.*\///;
  system("mv $pair1 $dir");
  system("perl -p -e 's/\n+/ /' $dir/$pair1 | perl -p -e 's/@/\n@/g' | sed '/^\$/d' > $dir/$pair1.'2'");
  $pair1 = $pair1.'.2'; 
  
  #Getting the identifiers 'barcodes' per Cell and the header
  if (-e "$dir/$pair1.'.IDs'") {
      my $identifiers =  $dir/$pair1.'.IDs';
    } else {
      my $identifiers = "sed 's/\:.*//g;' $dir/$pair1 | sort | uniq > $dir/$pair1.'IDs'";
      system ($identifiers);
  }
} 

# Getting and counting the total number of IDs
my $IDsFile = "$dir/$pair1.IDs";
my $numberofIDs = `wc -l < $dir/$pair1.'IDs'`; 
print ("$IDsFile\n"); 
print ("$numberofIDs");
# Getting the number of cells that should be included in each of the N fastq split files, 
  # and generating the ID's lists files to subset the input file/s
my $numberOfLinesToSplit = sprintf "%.0f", $numberofIDs/$numberOffastqs;
#mkdir "$dir/split_FastQ";  
#my $newdir = "$dir/split_FastQ";

open(IDSFILE, $IDsFile) or die "Could not read from $IDsFile, program halting.";  
my $count=0;
my $chunks;
while(<IDSFILE>){
    if(($.-1) %  $numberOfLinesToSplit == 0){
           close($chunks) if($chunks);
           open($chunks, '>', sprintf("$dir/$pair1.%02d.txt", ++$count)) or die $!;
        }
   print $chunks "$_";
}
close(IDSFILE);
print("Total number of cell IDs in fastq files = $numberofIDs"); 
# Read file in temporary folder containing the files of the cell ids to be used for splitting the bam 
my @array = <$dir/*txt>; 
  print Dumper (@array);
# create subroutine for splitting bam and using parallel processing
sub run_code {
  if ($typeData eq "paired") {
    my $temfiles=shift;
     system("perl $filteringScript $dir/$pair1  $temfiles |  sed 's/@/\\n@/g;' | sed 's/\\/1 /\\/1\\n/g;' | sed 's/ + /\\n+\\n/g;' | sed '/\^\$/d' > $temfiles'.R1.fq'");
     system("perl $filteringScript $dir/$pair2  $temfiles |  sed 's/@/\\n@/g;' | sed 's/\\/2 /\\/2\\n/g;' | sed 's/ + /\\n+\\n/g;' | sed '/\^\$/d' > $temfiles'.R2.fq'");
    
  } 
  if ($typeData eq "single") {
    my $temfiles=shift;
     system("perl $filteringScript $dir/$pair1  $temfiles |  sed 's/@/\\n@/g;' | sed 's/\\/1 /\\/1\\n/g;' | sed 's/ + /\\n+\\n/g;' | sed '/\^\$/d' > $temfiles'.R1.fq'");
  }
}
# Run the sub routine in parallel
for (@array) {
     run_back { run_code($_) };
}
# Report processing status
1 while wait != -1;
# Deleting 

unlink @array;
unlink $IDsFile;
unlink glob ("$dir/*.fastq");
unlink glob ("$dir/*.2");
$datestring = localtime();
print("Ending time = $datestring\n");
