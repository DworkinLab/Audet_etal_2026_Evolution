#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=30G
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=32
#SBATCH --array=0-36
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN

module load star/2.7.11b

genome=/home/audett/projects/def-idworkin/audett/prolongata/genome/carrolli
in=/home/audett/scratch/prolongata/merged_trimmed/car
out=/home/audett/scratch/prolongata/mapped_merged_trimmed/2pass_done/car

declare -a forward=( ${in}/*_R1_trimmed.fastq.gz )

R1=${forward[${SLURM_ARRAY_TASK_ID}]}

#files=(${in}/*_R1_trimmed.fastq.gz)
#name=${files}
base=`basename ${R1} _R1_trimmed.fastq.gz`


STAR --runThreadN 32 \
--quantMode TranscriptomeSAM GeneCounts \
--genomeDir ${genome} \
--readFilesIn ${in}/${base}_R1_trimmed.fastq.gz ${in}/${base}_R2_trimmed.fastq.gz \
--readFilesCommand zcat \
--outFileNamePrefix ${out}/${base} \
--outSAMtype BAM SortedByCoordinate \
--sjdbFileChrStartEnd ${genome}/sjdbList.out.tab

