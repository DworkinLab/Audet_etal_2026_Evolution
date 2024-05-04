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

First, I notice the gff files of the annotation are in a non-standard format that doesn't cooperate with STAR, so I use AGAT to convert gff to gtf. 

*not working right now* gff is formatted incorrectly



```
agat_gff2gtf_pro.sh
agat_gff2gtf_car.sh
```


## Indexing

carrolli annotation and genome do not match contig names, so I have to remove all of the extra information in the fasta headers except for the contig.

```
sed 's/^.*KB866 />/g' GCA_018152295.1_ASM1815229v1_genomic.fna > renameStep1_GCA_018152295.1_ASM1815229v1_genomic.fna
sed 's/,.*$//g' renameStep1_GCA_018152295.1_ASM1815229v1_genomic.fna > renamed_carrolli_genome.fa
star_index_car.sh
```

```
star_index_pro.sh
```

## Mapping

want to do 2-pass mapping, map all species samples first then use that junction output file as a junction annotation file to re-map all the samples.
```
star_pro.sh
star_car.sh
star_mel.sh
```
