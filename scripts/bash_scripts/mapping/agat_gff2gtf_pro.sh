#!/bin/bash
#SBATCH -t 0:30:00
#SBATCH -A def-idworkin
#SBATCH --cpus-per-task=32
#SBATCH --mem=10G
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load StdEnv/2020
module load agat/0.9.2

agat_convert_sp_gff2gtf.pl \
--in /home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata/prolongataSaPa_WGS-DeDup.gff \
--out /home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata/prolongataSaPa_WGS-DeDup_agat.gtf
