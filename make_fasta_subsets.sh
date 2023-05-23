#!/bin/bash
#SBATCH -t 2:00:00
#SBATCH -A def-idworkin
#SBATCH --array=0-225
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

in=/home/audett/scratch/prolongata/merged_trimmed
out=/home/audett/scratch/prolongata/merged_trimmed/blast

declare -a forward=( ${in}/*.fastq.gz )

R1=${forward[${SLURM_ARRAY_TASK_ID}]}

name=${R1}
base=`basename ${name} .fastq.gz`

less ${in}/${base}.fastq.gz | head -n 5000 | sed -n '1~4s/^@/>/p;2~4p' \
> ${in}/${base}.fasta
