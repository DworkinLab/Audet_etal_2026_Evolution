# prolongata_RNA-seq

Beginning with the RNAseq data in a folder called 'RNA', and the reference genomes for carrolli, prolongata, and melanogaster in a folder called 'genome' and sub-directories named after each species.

## Trimming
I have 226 R1 and 226 R2 files

first I run fastqc pre-trim - things look fine, adapters found

next I trim with 

'bbduk.sh'

second pass of fastqc also looks good. 

Next I split all reads from the first run in to their own directory called run1 and the second run in to a directory called run 2, while removing the beginning of the name added by Genome Quebec. I then merge these in to a single file using:

'merge.sh'

Next I need to find samples labelled the wrong species that I identified when blasting random sequences from the samples to look for possible issues. To do this I will blast every sample to the three species genomes.

'make_blast_db.sh'

'make_fasta_subset.sh'

'blastin.sh'

I can go through the outputted 'counts' file to identify samples that are blasting to the wrong species.

mel_M_mid_early_3 blasts to carrolli and prolongata equally and much better than melanogaster. I am going to leave this sample aside for the time being.
car_M_mid_early_6 blasts best to melanogaster so I will also leave this sample aside for now
A first run of the analysis identified pro_M_mid_late_2 and car_M_mid_late_2 as being outliers in PCR and appear to have strange extreme gene expression that doesn't match any other sample suggesting possible contamination, so I set these aside as well.

scaffold names don't match between the genomes and annotations for prolongata and carrolli, so I need to fix that.
`sed 's/.*Scaffold/\>Scaffold/g' GCA_036346975.1_ASM3634697v1_genomic.fna | sed 's/\,\ whole\ genome\ shotgun\ sequence//g' > prolongata_genome.fa`
`sed 's/.*contig/\>contig/g' GCA_018152295.1_ASM1815229v1_genomic.fna | sed 's/\,\ whole\ genome\ shotgun\ sequence//g' > carrolli_genome.fa`

Next step is mapping with STAR:

## Indexing

I need to convert my gff to a gtf so that STAR maps properly. Previous attempts at mapping to the gff directly resulted in very few hits, and genes not mapping at all that map when a gtf is used. The writer of star has suggested conversion when issues have been brought up [https://github.com/alexdobin/STAR/issues/901]

`gffread_convert_pro.sh`
`gffread_convert_car.sh`

and then I index
`star_index_pro.sh`
`star_index_car.sh`
`star_index_mel.sh`

## Mapping and counting

```
star_pro.sh
star_car.sh
star_mel.sh
```

I need a way to convert from the mRNA or gene numbers in the prolongata/carrolli annotations, to the geneIDs that are homologous with melanogaster, so I extract the information I need from the annotation for converting between all of these relevant things.

I run:
`orthoswapper_pro.r` via `orthoswapper_pro.sh`
`orthoswapper_car.r` via `orthoswapper_car.sh`

Next, I model each species separately and output emmeans contrasts and model estimates for each gene.

`pro_modelling.R` `car_modelling.R` `mel_modelling.R`


*************





***********

code that is not used in the current analysis

## OrthoFinder
Mapping is done to predicted genes, so I need to reciprocally blast these.

```
extract_prot_pro.sh
extract_prot_car.sh

# stop codons are denoted '.' in the output which is not accepted by NCBI downsatream, so I use sed 's/\./\*/g' to convert to '*' which is accepted
```
OrthoFinder was ran following the tutorial guidelines found at: https://davidemms.github.io/menu/tutorials.html

Protein sequences obtained from 'gffread' for Dmel, Dcar, and Dpro are all placed in a folder called proteomes, alog with downloaded translated prroteomes from D. rhopaloa and D. elegans obtained from NCBI RefSeq (GCF_018152115.1, GCF_018152505.1)

```
# extract the longest transcript from each gene to avoid falsely calling orthologues
for f in *fa ; do python /home/audett/OrthoFinder/tools/primary_transcript.py $f ; done

# run on the
/home/audett/OrthoFinder/orthofinder -f primary_transcripts/

# ran as a batch job
orthoFinder.sh
```


