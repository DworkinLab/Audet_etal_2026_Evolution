module load star/2.7.11b

STAR   --runMode genomeGenerate \
        --runThreadN 16 \
        --genomeDir /genome/prolongata \
        --genomeFastaFiles /genome/prolongata/prolongata_genome.fa \
        --sjdbGTFfile /genome/prolongata/prolongataSaPa_WGS-DeDup.gff \
        --sjdbOverhang 100 \
        --genomeSAindexNbases 12 \
        --sjdbGTFtagExonParentGene Parent
