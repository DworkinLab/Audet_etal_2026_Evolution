module load StdEnv/2020
module load seqtk/1.3

seqtk seq -a ${in}/${base}.fastq.gz > ${out}/${base}.fa
