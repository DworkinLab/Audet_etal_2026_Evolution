#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=20G
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1

module load python/3



virtualenv --no-download ENV
source ENV/bin/activate

#pip install --no-index --upgrade pip
#pip3 install RSeQC

in=/home/audett/scratch/prolongata/mapped_merged_trimmed/mel
#out=/home/audett/scratch/prolongata/mapped_merged_trimmed/mel/QC/rseqc

#declare -a forward=( ${in}/*Aligned.sortedByCoord.out.bam )

#R1=${forward[${SLURM_ARRAY_TASK_ID}]}

#files=(${in}/*_R1_trimmed.fastq.gz)
#name=${files}
#base=`basename ${R1} Aligned.sortedByCoord.out.bam`

python3 /home/audett/projects/def-idworkin/audett/prolongata/scripts/ENV/bin/geneBody_coverage.py \
-i ${in} \
-r  ~/projects/def-idworkin/arteen/SociabilityRNA/index/dmel-all-r6.38_good.bed \
-o ${in}/QC/rseqc
