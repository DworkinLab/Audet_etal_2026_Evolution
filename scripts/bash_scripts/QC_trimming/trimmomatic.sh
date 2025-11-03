#!/bin/bash
#SBATCH -t 4:00:00
#SBATCH -A def-idworkin
#SBATCH --array=0-225
#SBATCH --cpus-per-task=32
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load trimmomatic/0.39

in=/home/audett/projects/def-idworkin/audett/prolongata/RNA
out=/home/audett/scratch/prolongata/trimmed
adapters=/home/audett/projects/def-idworkin/audett/prolongata/genome/adapters.fa

declare -a forward=( ${in}/*_R1.fastq.gz )

R1=${forward[${SLURM_ARRAY_TASK_ID}]}

name=${R1}
base=`basename ${name} _R1.fastq.gz`

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar \
PE -threads 32 -trimlog ${out} \
${in}/${base}_R1.fastq.gz \
${in}/${base}_R2.fastq.gz \
${out}/${base}_R1_trimmed.fastq.gz \
${out}/${base}_R2_trimmed.fastq.gz \
ILLUMINACLIP:${adapters}:2:30:10 \
LEADING:3 TRAILING:3 MAXINFO:40:0.5 MINLEN:36
