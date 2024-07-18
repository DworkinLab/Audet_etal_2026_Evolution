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

trying to make gff work:
awk '{print $9}' prolongataSaPa_WGS-DeDup.gff > gff.info

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

## Reciprocal best hit blast

Using makeblastdb I created a nucleotide database for melanogaster, prolongata, and carrolli from the transcripts that I converted from gtf to fasta file with the readgff package. I then used blastn to blast prolongata/carrolli against melanogast and then melanogaster against prolongata/carrolli

```
extract_nuc_pro.sh

makedb.sh

pro2mel.sh
mel2pro.sh
car2mel.sh
mel2car.sh

```
I then run an R script that find the orthologs that are a best hit in both direction, and create an index.

```
ortho_reciprocator.R
```

And finally, I run an R script that replaces mRNA#### from the pro/car counts files with the identified reciprocal best hits from the index file
```
orthoswapper.sh
orthoswapper.r
```






