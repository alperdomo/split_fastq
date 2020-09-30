#usr/bin/perl

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
        my ($cell_id, $data1, $data2) = split(/ /, $line,3);
        print "$cell_id $data1\n$data2" if exists $params{$cell_id};
}
close(FASTQFILE);
close(IDS);
