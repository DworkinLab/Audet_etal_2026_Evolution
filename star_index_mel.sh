module load star/2.7.11b

STAR   --runMode genomeGenerate \
        --runThreadN 16 \
        --genomeDir /genome/melanogaster \
        --genomeFastaFiles /genome/melanogaster/dmel-all-chromosome-r6.59.fasta \
        --sjdbGTFfile /genome/melanogaster/dmel-all-r6.59.gff \
        --sjdbOverhang 100 \
        --genomeSAindexNbases 12 \
        --sjdbGTFtagExonParentGene Parent
