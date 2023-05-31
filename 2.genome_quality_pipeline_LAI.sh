########################################################
## shell script for genome quality assessment using LAI
########################################################

genome="P.densiflora_v1.0.HA.genome.fasta"	## for haplotypeB : P.densiflora_v1.0.HB.genome.fasta

#### run LTRharvest and LTR_FINDER_parallel for LAI input data
gt suffixerator -db $genome -indexname $genome -tis -suf -lcp -des -ssp -sds -dna >suffixerator.log 2>suffixerator.log2
gt ltrharvest -index $genome -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -motif TGCA -motifmis 1 -similar 85 -vic 10 -seed 20 -seqids yes > $genome.harvest.scn 2>ltrharvest.log2
LTR_FINDER_parallel -seq $genome -threads 100 -harvest_out -size 1000000 -time 300 >ltr_finder_parallel.log 2>ltr_finder_parallel.log2
cat $genome.harvest.scn $genome.finder.combine.scn > $genome.rawLTR.scn

#### run LTR_retriever for LAI input data
LTR_retriever -genome $genome -inharvest $genome.rawLTR.scn -threads 100 >ltr_retriever.log 2>ltr_retriever.log2

#### run LAI
LAI -genome $genome -intact $genome.pass.list -all $genome.out >lai.log 2>lai.log2
