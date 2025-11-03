# shell scripts for mapping and modelling

Beginning with the RNAseq data in a folder called 'RNA', and the reference genomes for carrolli, prolongata, and melanogaster in a folder called 'genome' and sub-directories named after each species.

## 1. QC_Trimming
As we used paired-end sequencing, we have 226 R1 and 226 R2 files. First I run fastqc pre-trim - things look fine, adapters found.

I trim with `bbduk.sh`.

A second pass of fastqc also looks good. 

## 2. merging

Next I split all reads from the first run in to their own directory called run1 and the second run in to a directory called run2, while removing the beginning of the name added by the sequencing centre. I then merge these in to a single file using: `merge.sh`

## 3. blasting_between_spp

Before anything, I did a quick check by blasting some sequences from each fastq using the online blast tool. I identified two samples that appeared to be blasting to incorrect species (a melanogaster to a carrolli and the reverse), so I check all samples to make sure they blast best to the species which they are labelled as.

`make_blast_db.sh`

`make_fasta_subset.sh`

`blastin.sh`

I can go through the outputted 'counts' file to identify samples that are blasting to the wrong species.

mel_M_mid_early_3 blasts to carrolli and prolongata equally and much better than melanogaster. I am going to leave this sample aside for the time being.
car_M_mid_early_6 blasts best to melanogaster so I will also leave this sample aside for now.

* A first run of the analysis identified pro_M_mid_late_2 and car_M_mid_late_2 as being outliers in PCR and appear to have strange extreme gene expression that doesn't match any other sample suggesting possible tissue contamination, so I set these aside as well.

## 4. mapping
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

## 5. converting_geneNames

I need a way to convert from the gene numbers in the prolongata/carrolli annotations, to the geneIDs that are orthologous with melanogaster, so I extract the information I need from the annotation for converting between all of these relevant things.

I run:

`orthoswapper_pro.r` via `orthoswapper_pro.sh`

`orthoswapper_car.r` via `orthoswapper_car.sh`

## 6. modelling

Next, I model each species separately and output emmeans contrasts and model estimates for each gene.

`pro_modelling.R` via `pro_model.sh`

`car_modelling.R` via `car_model.sh`

`mel_modelling.R` via `mel_model.sh`

# Rscripts for analyses

## 1. PCA
This script generates Figures 2 and 3, and corresponds to the results section "Expression profiles show species and sex-specific clustering, with little evidence for clustering based on specific leg imaginal disc, or developmental stage"

`PCA_work.Rmd`

## 2. Magnitude and gene number relationship with SSD
This script generates Figure 4 and corresponds to the results section  "Sex-biased gene expression in D. prolongata forelegs is species-specific"

`MagnitudesDistancesBetweenVectors.Rmd`

## 3. Differential expression analysis
This script generates Figure 5 and corresponds to the results section "Sex-biased gene expression in D. prolongata forelegs is species-specific"

`DEG_analysis.Rmd`

## 4. Functional analysis
This scripts generates Figure 7 and corresponds to the results section "RNAi knockdowns of a subset of our candidates shows changes to femur width and length as well as a qualitatively D. prolongata-like phenotype in D. melanogaster femurs"

`PenGAL4_cross.Rmd`

## 5. Vector correlation analyses
This script generates Figures 8, 9, and 10 and corresponds to the results section "Signalling pathways and candidate sex-biased genes appear to be expressed in similar direction and magnitude between all three species" and "Sex-biased expression in key signalling pathways are broadly similar in direction and magnitude between all three species"

`Vector_Correlations.Rmd`

## 6. DeSeq checks
This script corresponds with Supplemental Figures 1 and 2 and is a sanity check to ensure that our methods are roughly in line with the standard DESeq pipeline methods.
`DeSeq_analysis.Rmd`
