#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0:30:00
#SBATCH --cpus-per-task=16
#SBATCH --output=Star_index_pro.out

module load star/2.7.11b

STAR   --runMode genomeGenerate \
        --runThreadN 16 \
        --genomeDir /home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata \
        --genomeFastaFiles /home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata/prolongata_genome.fa \
	--sjdbGTFfile /home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata/prolongataSaPa_WGS-DeDup_agat.gtf \
	--sjdbOverhang 100 \
	--genomeSAindexNbases 12
#        --sjdbGTFtagExonParentGene Parent
