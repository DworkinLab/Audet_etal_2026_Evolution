#!/bin/bash

#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=32G
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8
#SBATCH --output=mel_model.out
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load r/4.4.0

Rscript mel_modelling.R
