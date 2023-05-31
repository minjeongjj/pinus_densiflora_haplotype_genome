use strict;

my @stGlob = glob ("Results/Chr*.dedup.gvcf.gz");

open (OUT, ">gatk.map");
for (my $i=0; $i<@stGlob; $i++)
{
	(my $stChr = $stGlob[$i]) =~ s/Results\/|\.dedup\.gvcf\.gz//g;
	print OUT "$stChr\t$stGlob[$i]\n";
}
close OUT;
