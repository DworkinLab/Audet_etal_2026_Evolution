run1=run1
run2=run2
out=merged_trimmed

declare -a forward=( ${run1}/*.fastq.gz )

R1=${forward[${SLURM_ARRAY_TASK_ID}]}

name=${R1}
base=`basename ${name} .fastq.gz`

cat ${run1}/${base}.fastq.gz ${run2}/${base}.fastq.gz > ${out}/${base}.fastq.gz



