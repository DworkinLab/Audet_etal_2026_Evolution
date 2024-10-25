module load bbmap/39.06

in=RNA
out=trimmed

declare -a forward=( ${in}/*_R1.fastq.gz )

R1=${forward[${SLURM_ARRAY_TASK_ID}]}

name=${R1}
base=`basename ${name} _R1.fastq.gz`

bbduk.sh \
in1=${in}/${base}_R1.fastq.gz \
in2=${in}/${base}_R2.fastq.gz \
out1=${out}/${base}_R1_trimmed.fastq.gz \
out2=${out}/${base}_R2_trimmed.fastq.gz \
ref=/genome/adapters.fa \
threads=32 ftr=100 ktrim=r k=21 mink=10 hdist=1 tpe tbo \
qtrim=rl trimq=15 minlength=36 rcomp=t
