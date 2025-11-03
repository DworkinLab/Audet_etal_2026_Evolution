#!/bin/bash
#SBATCH -t 3:00:00
#SBATCH -A def-idworkin
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load blast+/2.14.1

in=/home/audett/scratch/prolongata/fasta_subsets

files=(${in}/*.fa)

for file in ${files[@]}; do
name=${file}
base=`basename ${name} .fa`

echo ${base} >> counts
echo melanogaster >> counts
blastn -db /home/audett/projects/def-idworkin/audett/prolongata/genome/blast_dbs/all_genomes_db.fa \
-query ${in}/${base}.fa |
grep "loc=" | wc -l >> counts

echo prolongata >> counts
blastn -db /home/audett/projects/def-idworkin/audett/prolongata/genome/blast_dbs/all_genomes_db.fa \
-query ${in}/${base}.fa |
grep "prolongata" | wc -l >> counts

echo carrolli >> counts
blastn -db /home/audett/projects/def-idworkin/audett/prolongata/genome/blast_dbs/all_genomes_db.fa \
-query ${in}/${base}.fa |
grep "carrolli" | wc -l >> counts

done
