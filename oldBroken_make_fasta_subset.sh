# This currently doesn't seem to work

less /prolongata/merged_trimmed/*.fastq.gz | head -n 5000 | sed -n '1~4s/^@/>/p;2~4p' \
> /prolongata/fasta_subsets/{file}.fasta
