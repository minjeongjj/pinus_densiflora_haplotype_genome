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

	print "gatk --java-options \"-Xmx16g -XX:ParallelGCThreads=3\" HaplotypeCaller -R $stGenome -I Results/LM.dedup.bam -O Results/$stChr.dedup.gvcf.gz -ERC GVCF --native-pair-hmm-threads 40 -L $stChr 2>$stChr.log2 &\n";
}
