# prolongata_RNA-seq

Beginning with the RNAseq data in a folder called 'RNA', and the reference genomes for carrolli, prolongata, and melanogaster in a folder called 'genome' and sub-directories named after each species.

## 1. Trimming
I have 226 R1 and 226 R2 files. First I run fastqc pre-trim - things look fine, adapters found.

I trim with `bbduk.sh`.

A second pass of fastqc also looks good. 

## 2. merging files

Next I split all reads from the first run in to their own directory called run1 and the second run in to a directory called run2, while removing the beginning of the name added by the sequencing centre. I then merge these in to a single file using: `merge.sh`

## 3. Blasting to make sure things look good

Before anything, I did a quick check by blasting some sequences from each fastq using the online blast tool. I ientified two samples that appeared to be blasting to incorrect species (a melanogaster to a carrolli and the reverse), so I check all samples to make sure they blast best to the species which they are labelled as.

`make_blast_db.sh`

`make_fasta_subset.sh`

`blastin.sh`

I can go through the outputted 'counts' file to identify samples that are blasting to the wrong species.

mel_M_mid_early_3 blasts to carrolli and prolongata equally and much better than melanogaster. I am going to leave this sample aside for the time being.
car_M_mid_early_6 blasts best to melanogaster so I will also leave this sample aside for now

* A first run of the analysis identified pro_M_mid_late_2 and car_M_mid_late_2 as being outliers in PCR and appear to have strange extreme gene expression that doesn't match any other sample suggesting possible tissue contamination, so I set these aside as well.

## 4. Mapping
scaffold names don't match between the genomes and annotations for prolongata and carrolli, so I need to fix that and make names match for mapping.
`sed 's/.*Scaffold/\>Scaffold/g' GCA_036346975.1_ASM3634697v1_genomic.fna | sed 's/\,\ whole\ genome\ shotgun\ sequence//g' > prolongata_genome.fa`
`sed 's/.*contig/\>contig/g' GCA_018152295.1_ASM1815229v1_genomic.fna | sed 's/\,\ whole\ genome\ shotgun\ sequence//g' > carrolli_genome.fa`

I need to convert my gff to a gtf so that STAR maps properly. Previous attempts at mapping to the gff directly resulted in very few hits, and genes not mapping at all that map when a gtf is used. The writer of star has suggested conversion when issues have been brought up [https://github.com/alexdobin/STAR/issues/901]

I attempted this step with both gffread and aagat, gffread appears to not convert the D. prolongata gff properly resulting in very few genes mapping, agat however results in similar mapping numbers as D. melanogaster to the well established FlyBase gtf annotation. So going forward I use the agat converted gff -> gtf

`agat_gff2gtf_pro.sh`
`agat_gff2gtf_car.sh`

and then I index each species genome and annotation.
`star_index_pro.sh`
`star_index_car.sh`
`star_index_mel.sh`

mapping was run in the 2-pass method recomended in the manual. The scripts were run once without splice site annotations, and then ran a second time with `--sjdbFileChrStartEnd /path/to/sjdbFile.txt.`

```
star_pro.sh
star_car.sh
star_mel.sh

```

The 2-pass mapping really didn't seem to make much of a difference. But it didn't hurt anything, so on we go.



I need a way to convert from the gene numbers in the prolongata/carrolli annotations, to the geneIDs that are homologous with melanogaster, so I extract the information I need from the annotation for converting between all of these relevant things.

I run:
`orthoswapper_pro.r` via `orthoswapper_pro.sh`
`orthoswapper_car.r` via `orthoswapper_car.sh`

Next, I model each species separately and output emmeans contrasts and model estimates for each gene.

`pro_modelling.R` `car_modelling.R` `mel_modelling.R`


*************




