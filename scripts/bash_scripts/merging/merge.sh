#!/bin/bash
#SBATCH -t 4:00:00
#SBATCH -A def-idworkin
#SBATCH --array=0-225
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

run1=/home/audett/scratch/prolongata/run1
run2=/home/audett/scratch/prolongata/run2
out=/home/audett/scratch/prolongata/merged_trimmed

declare -a forward=( ${run1}/*.fastq.gz )

R1=${forward[${SLURM_ARRAY_TASK_ID}]}

name=${R1}
base=`basename ${name} .fastq.gz`

cat ${run1}/${base}.fastq.gz ${run2}/${base}.fastq.gz > ${out}/${base}.fastq.gz
