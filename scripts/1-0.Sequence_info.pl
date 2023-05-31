use strict;

my $stGenome = $ARGV[0];

my ($stChr);
open (Genome, "$stGenome");
while (my $stLine = <Genome>)
{
	chomp $stLine;
	if ($stLine =~ />([^\s\t]+)/)
	{
		$stChr = $1;
	}
	else
	{
		my $nLen = length $stLine;
		print "$stChr\t$nLen\n";
	}
}
close Genome;
