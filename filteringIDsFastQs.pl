#usr/bin/perl

##------------------------scATAC-seq Analysis---------------------##
## Alvaro Perdomo-Sabogal                                         ##
## Garfieldlab, HU, 2019                                          ## 
##                                                                ##
##------------------------ HELPER NOTES---------------------------##
# This is a script that is used by a subroutine within  the script:#
# split_fastq_sciATAC.pl 				           #
##-----------------------------------------------------------------#
use strict;
use warnings"all";

my $sampleFastq = $ARGV[0];
my $IDs = $ARGV[1];
open (FASTQFILE, '<', "$sampleFastq");
open (IDS, '<', "$IDs");
my %params;
while (my $line = <IDS>) {
	chomp $line;
	$params{$line} = $line;
}
while (my $line = <FASTQFILE>) {
        chomp $line;
        my ($cell_id, $data) = split(/:/, $line,2);
        print "$cell_id:$data\n" if exists $params{$cell_id};
}
close(FASTQFILE);
close(IDS);

