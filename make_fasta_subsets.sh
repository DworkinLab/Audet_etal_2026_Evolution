module load StdEnv/2020
module load seqtk/1.3

seqtk sample -s100 ${in}/${base}.fastq.gz 5000 > ${out}/${base}.fq

seqtk seq -a ${out}/${base}.fq > ${out}/${base}.fa
