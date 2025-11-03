#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=20G
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --array=0-36

in=/home/audett/scratch/prolongata/mapped_merged_trimmed/pro
out=/home/audett/scratch/prolongata/mapped_merged_trimmed/pro/QC/qorts

declare -a forward=( ${in}/*Aligned.sortedByCoord.out.bam )

R1=${forward[${SLURM_ARRAY_TASK_ID}]}

#files=(${in}/*_R1_trimmed.fastq.gz)
#name=${files}
base=`basename ${R1} Aligned.sortedByCoord.out.bam`

gtf_file=/home/audett/projects/def-idworkin/audett/prolongata/genome/pro/formatted_2.gtf

genome_fasta=/home/audett/projects/def-idworkin/audett/prolongata/genome/pro/prolongata_renamed_assembly.fasta

raw_dir=/home/audett/scratch/prolongata/merged_trimmed/pro
raw1=${base}_R1_trimmed.fastq.gz
raw2=${base}_R2_trimmed.fastq.gz

# command
mkdir ${out}/${base}
java -jar -Xmx8G ~/projects/def-idworkin/audett/prolongata/scripts/QoRTs.jar QC \
                   --generatePlots \
                   --genomeFA ${genome_fasta} \
                   --rawfastq ${raw_dir}/${raw1},${raw_dir}/${raw2} \
                   ${in}/${base}Aligned.sortedByCoord.out.bam \
                   ${gtf_file} \
                   ${out}/${base}/
