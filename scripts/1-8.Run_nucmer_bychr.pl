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

	(my $stConsen = $stInfo[0]) =~ s/A$//;
	print "nucmer --mum -l 1000 -c 200 -g 200 -t 1 -p $stConsen $stConsen\A.fa $stConsen\B.fa && show-snps -Clr $stConsen.delta > $stConsen.snps&\n";
}
close CLC;
