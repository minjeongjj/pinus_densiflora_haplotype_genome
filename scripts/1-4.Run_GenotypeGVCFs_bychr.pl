use strict;

my $stCLC = $ARGV[0];
my $stGenome = $ARGV[1];

my ($nCnt);
open (CLC, "$stCLC");
while (my $stLine = <CLC>)
{
	chomp $stLine;
	$nCnt ++;
	my @stInfo = split " ", $stLine;
	
	next if ($stLine !~ /Chr/);
	
	my $stChr = $stInfo[0];

	print "gatk --java-options \"-Xmx10g\" GenotypeGVCFs -R $stGenome -V gendb://db/$stChr -O vcf/$stChr.vcf.gz&\n";	
}
close CLC;
