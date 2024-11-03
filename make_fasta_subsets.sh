module load StdEnv/2020
module load seqtk/1.3

less merged_trimmed/${base}.fastq.gz | head -n 10000 > fasta_subsets/${base}.fq

seqtk seq -a fasta_subsets/${base}.fq > fasta_subsets/${base}.fa
