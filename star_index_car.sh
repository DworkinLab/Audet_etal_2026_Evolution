module load star/2.7.11b

STAR   --runMode genomeGenerate \
        --runThreadN 16 \
        --genomeDir /genome/carrolli \
        --genomeFastaFiles /genome/carrolli/carrolli_genome.fa \
        --sjdbGTFfile /genome/carrolli/carrolli_GCA_018152295.1.gff \
        --sjdbOverhang 100 \
        --genomeSAindexNbases 12 \
        --sjdbGTFtagExonParentGene Parent
