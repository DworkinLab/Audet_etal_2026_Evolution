#!/bin/bash
#SBATCH -t 0:30:00
#SBATCH -A def-idworkin
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load blast+/2.14.1

makeblastdb -in \
"/home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata/GCA_036346975.1_ASM3634697v1_genomic.fna\
 /home/audett/projects/def-idworkin/audett/prolongata/genome/carrolli/GCA_018152295.1_ASM1815229v1_genomic.fna\
 /home/audett/projects/def-idworkin/audett/prolongata/genome/melanogaster/dmel-all-chromosome-r6.59.fasta"\
 -title all_fly_genomes -dbtype nucl -out all_genomes_db.fa
