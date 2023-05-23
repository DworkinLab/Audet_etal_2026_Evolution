# prolongata_RNA-seq

## Trimming
I have 226 R1 and 226 R2 files

first I run fastqc pre-trim - things look fine, adapters found

next I trim with 'bbduk.sh'

second pass of fastqc also looks good. Next I split all reads from the first run in to their own directory called run1 and the second run in to a directory called run 2, while removing the beginnig of the name added by Genome Quebec. I then merge these in to a single file using 'merge.sh'.

Next I need to find samples labelled the wrong species that I identified when blasting the samples to look for possible issues. To do this I will blast every sample to the three species genomes.
'make_blast_db.sh'
'make_fasta_subsets.sh'
'blastin.sh'

Next step is mapping with STAR:

scaffold names need to be the same in genome and transcriptome.

want to use chimeric reads since contigs may not be whole chromosomes

want to do 2-pass mapping, map all species samples first then use that junction output file as a junction annotation file to re-map all the samples.



