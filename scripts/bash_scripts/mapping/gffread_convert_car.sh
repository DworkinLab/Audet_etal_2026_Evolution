#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0:30:00
#SBATCH --cpus-per-task=16
#SBATCH --output=gffread_car.out

module load StdEnv/2020
module load gffread/0.12.3

gffread /home/audett/projects/def-idworkin/audett/prolongata/genome/carrolli/carrolli_GCA_018152295.1.gff \
-T -o /home/audett/projects/def-idworkin/audett/prolongata/genome/carrolli/carrolli_GCA_018152295.1.gtf
