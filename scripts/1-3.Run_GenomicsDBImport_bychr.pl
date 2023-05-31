use strict;

my $stCLC = $ARGV[0];

my ($nCnt);
open (CLC, "$stCLC");
while (my $stLine = <CLC>)
{
	chomp $stLine;
	$nCnt ++;
	my @stInfo = split " ", $stLine;

	next if ($stLine !~ /Chr/);	

	my $stChr = $stInfo[0];
	
	print "gatk --java-options \"-Xmx10g -Xms10g\" GenomicsDBImport --genomicsdb-workspace-path db/$stChr --batch-size 50 -L $stChr --sample-name-map gatk.map --reader-threads 2&\n";
}
close CLC;
