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

	print "whatshap phase --ignore-read-groups -o $stChr.phased.vcf --reference=$stGenome --chromosome $stChr --sample=$stChr vcf/$stChr.vcf.gz pb.sorted.bam &\n";
}
close CLC;
