#!/bin/bash

# Run the de novo pipeline on pre-processed reads
# Usage: ./de_novo FORWARD_READS REVERSE_READS OUTPUT [SSPACE_INSERT_SIZE]

INSERT_SIZE=200

if [ "$#" -lt 3 ]; then
    >&2 echo "Error: Incorrect number of arguments."
    >&2 echo "Usage: $0 FORWARD_READS REVERSE_READS OUTPUT_FILE [SSPACE_INSERT_SIZE]"
    exit 1
fi

if [ "$#" -eq 4 ]; then
    INSERT_SIZE=$4
fi

# Run skesa and save result into $3.skesa.tmp file
skesa --fastq $1,$2 --use_paired_ends > "$3.skesa.tmp"

echo "Running scaffolding"

# Create config file for sspace
echo -n "lib1 bowtie $1 $2 $INSERT_SIZE 0.99 FR" > "$3.lib.tmp"

# Create random output folder for sspace
out=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10`

SSPACE_Standard_v3.0.pl -l "$3.lib.tmp"  -s "$3.skesa.tmp" -b "$out" -x 1

mv "$out/$out.final.scaffolds.fasta" "$3"

rm "$3.skesa.tmp"
rm "$3.lib.tmp"
rm -r "$out"
