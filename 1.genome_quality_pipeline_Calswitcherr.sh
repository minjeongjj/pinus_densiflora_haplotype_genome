##########################################################################
## shell script for genome quality assessment using Calcswitch_err
##########################################################################
#!/bin/bash

genome="P.densiflora_v1.0.HA.genome.fasta"	## use haplotype A as reference genome following the Calcswitch_err pipeline
shortread1="pden.shortread.PE.Q20.fq.1.fq"	## quality trimmed short read sequencing data (R1)
shortread2="pden.shortread.PE.Q20.fq.2.fq"	## quality trimmed short read sequencing data (R2)

############################## step1: run GATK for input data of Calcswitch_err #################################################
#### run bwa mem (map reads to reference)
mkdir Results/
bwa index -a bwtsw $genome -p $genome
bwa mem -t 100 -M -R '@RG\tID:LM\tLB:LM\tPL:ILLUMINA\tSM:LM' $genome $shortread1 $shortread2 | samtools_0.1.18 view -bS - > Results/LM.bam

#### make duplicates
mkdir ./tmp
gatk --java-options '-Xmx200G' MarkDuplicatesSpark --spark-master local[20] --tmp-dir ./tmp -I Results/LM.bam -O Results/LM.dedup.bam -M Results/LM.dedup.metrics --remove-all-duplicates true 2>LM.dedup.bam.err

#### creating dict file for reference genome
gatk CreateSequenceDictionary -R $genome

#### creating the fasta index file
samtools_0.1.18 faidx $genome

#### call variants by chromosome
gatk --java-options "-Xmx2000g" HaplotypeCaller --native-pair-hmm-threads 150 -R $genome -I Results/LM.dedup.bam -O Results/LM.dedup.gvcf.gz -ERC GVCF 2>LM.gvcf.gz.err		# this step takes many times for pinetree

#### run haplotypecaller by each chromosome (Chr1A - 12A)
perl scripts/1-0.Sequence_info.pl $genome > clc.$genome 
perl scripts/1-1.Run_haplotypecaller_bychr.pl clc.$genome $genome > 1-1.Run_haplotypecaller_bychr.sh
sh 1-1.Run_haplotypecaller_bychr.sh

#### merge gvcf
bcftools concat -o merge.gvcf Results/Chr*gz

#### indexing gvcf by each chromosome (Chr1A - 12A)
perl scripts/1-2.Build_map.pl > 1-2.Build_map.sh
sh 1-2.Build_map.sh

#### create genomicdb by each chromosome (Chr1A - 12A)
mkdir db/
perl scripts/1-3.Run_GenomicsDBImport_bychr.pl clc.$genome > 1-3.Run_GenomicsDBImport_bychr.sh
sh 1-3.Run_GenomicsDBImport_bychr.sh

#### call variants and build vcf file by each chromosome (Chr1A - 12A)
mkdir vcf/
perl scripts/1-4.Run_GenotypeGVCFs_bychr.pl clc.$genome $genome > 1-4.Run_GenotypeGVCFs_bychr.sh 
sh 1-4.Run_GenotypeGVCFs_bychr.sh

#### merge vcf
bcftools concat vcf/Chr*.vcf.gz -Oz > merge.vcf.gz

#### output : merge.vcf.gz -> final vcf for Calcswitch_err input data

###########################################################################################################################

########################### step 2: run Whatshap for input data of Calcswitch_err #########################################

longread="20190306.KoreanPine.pacbio.fasta"	## long read sequencing data

#### run minimap2 (this command can be preceded while step1 is in progress)
minimap2 -t 150 -ax map-pb --secondary=no $genome $longread | samtools view -bt $genome.fai - | samtools sort -@ 150 -o pb.sorted.bam - >minimap.log 2>minimap.log2

#### run whatshap by each chromosome (Chr1A - 12A) (this step must be conducted after step1 is fully complete)
samtools_0.1.18 index pb.sorted.bam
perl scripts/1-5.Run_whatshap_bychr.pl clc.$genome $genome > 1-5.Run_whatshap_bychr.sh
sh 1-5.Run_whatshap_bychr.sh

#### cat whatshap by each chromosome (Chr1A - 12A)
perl scripts/1-6_Cat_phasedvcf.pl > 1-6_Cat_phasedvcf.sh
sh 1-6_Cat_phasedvcf.sh
cat pb.*.phased.vcf > PB.WH.phase.txt

#### output : PB.WH.phase.txt -> final txt file for Calcswitch_err input data

###########################################################################################################################

############################# step 3: run Nucmer for input data of Calcswitch_err #########################################

genome_hb="P.densiflora_v1.0.HB.genome.fasta"	## haplotype B genome file

#### split genome by chromosomes
perl scripts/1-7.Split_genomefile.pl $genome
perl scripts/1-7.Split_genomefile.pl $genome_hb

#### run nucmer by each chromosome (Chr1A - 12A) (this command can be preceded while step1 and step2 is in progress)
perl scripts/1-8.Run_nucmer_bychr.pl clc.$genome > 1-8.Run_nucmer_bychr.sh
sh 1-8.Run_nucmer_bychr.sh

cat Chr*.snps |grep Chr |grep -v home|perl -e 'while(<>){chomp;$_=~s/^\s+//;@t=split(/\s+/,$_);print "$t[13]\t$t[0]\t$t[1]\t$t[14]\t$t[3]\t$t[2]\n" if($t[1] ne "." and $t[2] ne ".")}' > ALLHiC.hapVar.snps

#### output : ALLHiC.hapVar.snps -> final snp information file for Calcswitch_err input data

############################################################################################################################

############################# step 4: run Calcswitch_err ###################################################################
perl scripts/calc_swtichErr.pl PB.WH.phase.txt ALLHiC.hapVar.snps > Stat.switcherr

#### output : Stat.switcherr -> final result file for Calcswitch_err
