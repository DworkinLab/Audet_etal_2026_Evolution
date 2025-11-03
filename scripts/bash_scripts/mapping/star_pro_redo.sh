#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=50G
#SBATCH --time=08:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN

module load star/2.7.11b

genome=/home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata
in=/home/audett/scratch/prolongata/merged_trimmed/pro
out=/home/audett/scratch/prolongata/mapped_merged_trimmed/pro

#declare -a forward=( ${in}/*_R1_trimmed.fastq.gz )

#R1=${forward[${SLURM_ARRAY_TASK_ID}]}

#files=(${in}/*_R1_trimmed.fastq.gz)
#name=${files}
#base=`basename ${R1} _R1_trimmed.fastq.gz`


STAR --runThreadN 24 \
--quantMode TranscriptomeSAM GeneCounts \
--genomeDir ${genome} \
--readFilesIn ${in}/pro_F_for_early_2_R1_trimmed.fastq.gz ${in}/pro_F_for_early_2_R1_trimmed.fastq.gz \
--readFilesCommand zcat \
--outFileNamePrefix ${out}/pro_F_for_early_2 \
--outSAMtype BAM SortedByCoordinate
