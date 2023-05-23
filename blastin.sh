#!/bin/bash
#SBATCH -t 6:00:00
#SBATCH -A def-idworkin
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load gcc/9.3.0
module load blast+/2.13.0

in=/home/audett/scratch/prolongata/merged_trimmed/blast

files=(${in}/*.fasta)

for file in ${files[@]}; do
name=${file}
base=`basename ${name} .fasta`

echo ${base} >> counts
echo melanogaster >> counts
blastn -db all_genomes.fa -query ${in}/${base}.fasta |
grep "loc=" | wc -l >> counts

echo prolongata >> counts
blastn -db all_genomes.fa -query ${in}/${base}.fasta |
grep ">D" | wc -l >> counts

echo carrolli >> counts
blastn -db all_genomes.fa -query ${in}/${base}.fasta |
grep ">J" | wc -l >> counts

done
