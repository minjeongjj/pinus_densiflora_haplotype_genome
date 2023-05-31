use strict;

my @stGlob = glob ("*.phased.vcf");

for (my $i=0; $i<@stGlob; $i++)
{
	print "perl 1-6.Cat_phasedvcf.pl $stGlob[$i] > pb.$stGlob[$i] &\n";	
}
