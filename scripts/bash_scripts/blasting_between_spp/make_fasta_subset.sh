#!/bin/bash
#SBATCH -t 0:30:00
#SBATCH -A def-idworkin
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load StdEnv/2020
module load seqtk/1.3


in=/home/audett/scratch/prolongata/merged_trimmed
out=/home/audett/scratch/prolongata/fasta_subsets

#declare -a forward=( ${in}/*.fastq.gz )

#R1=${forward[${SLURM_ARRAY_TASK_ID}]}

files=${in}/*.fastq.gz

for file in ${files[@]}
do
name=${file}
base=`basename ${name} .fastq.gz`
#echo ${base}
#echo $(less ${in}/${base}.fastq.gz | head -n 5000 | sed '1~4s/^@/>/' | grep -A 1 --no-group-separator '>') \
#> ${out}

less ${in}/${base}.fastq.gz | head -n 10000 > ${out}/${base}.fq

seqtk seq -a ${out}/${base}.fq > ${out}/${base}.fa

done

