use strict;

my $PhaseVcf = $ARGV[0];

(my $stChr = $PhaseVcf) =~ s/.phased.vcf//g;
my ($nColumn);
open (VCF, "$PhaseVcf");
while (my $stLine = <VCF>)
{
	chomp $stLine;
	if ($stLine =~ /#CHROM/)
	{
		my @stHead = split " ", $stLine;
		for (my $i=0; $i<@stHead; $i++)
		{
			$nColumn = $i if ($stHead[$i] eq $stChr);
		}
	}
	else
	{
		next if ($stLine =~ /^#/);
		my @stInfo = split " ", $stLine;
		my @stID = split /:/, $stInfo[$nColumn];
		next if ($stID[0] !~ /^0\|1$|^1\|0$/);
		print "$stInfo[0]\t$stInfo[1]\t$stInfo[3]\t$stInfo[4]\t$stInfo[$nColumn]\n";
	}
	
}
close VCF;
