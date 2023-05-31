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
		next if $stChr !~ /Chr/;

		open (OUT, ">$stChr.fa");
		print OUT ">$stChr\n$stLine\n";
		close OUT;
	}
}
close Genome;
