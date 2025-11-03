#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0:30:00
#SBATCH --cpus-per-task=16
#SBATCH --output=Star_index_pro.out

module load star/2.7.11a

STAR   --runMode genomeGenerate \
        --runThreadN 16 \
        --genomeDir /home/audett/projects/def-idworkin/audett/prolongata/genome/pro \
        --genomeFastaFiles /home/audett/projects/def-idworkin/audett/prolongata/genome/pro/prolongataSaPa_WGS-DeDup.fa \
        --sjdbGTFtagExonParentGene gene \
	--sjdbGTFfile /home/audett/projects/def-idworkin/audett/prolongata/genome/pro/prolongataSaPa_WGS-DeDup.gff \
	--sjdbOverhang 100 \
	--genomeSAindexNbases 12

