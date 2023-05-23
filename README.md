# prolongata_RNA-seq

## Trimming
I have 226 R1 and 226 R2 files

first I run fastqc pre-trim - things look fine, adapters found

next I trim with 'bbduk.sh'

second pass of fastqc also looks good. Next I split all reads from the first run in to their own directory called run1 and the second run in to a directory called run 2, while removing the beginnig of the name added by Genome Quebec. I then merge these in to a single file using 'merge.sh'.





