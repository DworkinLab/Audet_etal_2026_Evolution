#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH -A def-idworkin
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# The following two lines do not work so I need to remove the start of the file name manually
# for f in *; do mv "$f" "${f:5}"; done

#for f in /home/audett/scratch/prolongata/trimmed/*2098*; do mv "$f" /home/audett/scratch/prolongata/run1/"${f:40}"; done
#for f in /home/audett/scratch/prolongata/trimmed/*2111*; do mv "$f" /home/audett/scratch/prolongata/run2/"${f:40}"; done


mv /home/audett/scratch/prolongata/trimmed/*2098* /home/audett/scratch/prolongata/run1/

mv /home/audett/scratch/prolongata/trimmed/*2111* /home/audett/scratch/prolongata/run2/

#mv /home/audett/scratch/prolongata/run1/*gz /home/audett/scratch/prolongata/trimmed/

#mv /home/audett/scratch/prolongata/run2/*gz /home/audett/scratch/prolongata/trimmed/

