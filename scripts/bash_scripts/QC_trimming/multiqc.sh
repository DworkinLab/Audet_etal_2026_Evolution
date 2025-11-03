#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH -A def-idworkin
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

multiqc /home/audett/scratch/prolongata/trimmed/after_QC/
