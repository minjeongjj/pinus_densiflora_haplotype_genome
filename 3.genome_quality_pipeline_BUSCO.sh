##########################################################################
## shell script for whole gene annotation quality assessment using BUSCO
##########################################################################
#!/bin/bash

pep="P.densiflora_v1.0_HA.PEP.fa"	## for haplotypeB : P.densiflora_v1.0_HB.PEP.fa 

#### run BUSCO
export BUSCO_CONFIG_FILE=/your/path/busco/config/config.ini
python3 /your/path/busco/src/busco/run_BUSCO.py -i $pep -o $pep.busco -l /your/path/busco/DB/embryophyta_odb10 -m prot -c 150
