#!/bin/bash

#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=32G
#SBATCH --time=8:00:00
#SBATCH --cpus-per-task=8
#SBATCH --output=mel_model.out
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load StdEnv/2020 gcc/9.3.0

module load r/4.1.2

Rscript mel_modelling.R
