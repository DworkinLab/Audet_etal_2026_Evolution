#!/bin/bash
#SBATCH --account=def-idworkin
#SBATCH --mem-per-cpu=7G
#SBATCH --time=0:30:00
#SBATCH --array=0-35
#SBATCH --output=orthoswapper_pro.out
#SBATCH --mail-user=audett@mcmaster.ca
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN

module load StdEnv/2020
module load r/4.1.2

### Initialization

in=/home/audett/projects/def-idworkin/audett/prolongata/data/pro

# Get Array ID
declare -a forward=( ${in}/*ReadsPerGene.out.tab )
R1=${forward[${SLURM_ARRAY_TASK_ID}]}

name=${R1}
base=`basename ${name} ReadsPerGene.out.tab`

# Output file
outFile=${base}

Rscript --vanilla orthoswapper_pro.r ${R1}
