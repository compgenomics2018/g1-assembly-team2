#!/usr/bin/env bash

# Helper script to run Skesa on all reads. The path to the reads folder is hardcoded,
# the final pipeline will accept a list of paired reads as an argument

ROOT="/projects/data/sra_1_fastq_trimmedFINAL"

ls $ROOT | grep "_1_" | cut -f1 -d_ | xargs -I{} bash -c \
"./run_skesa.sh $ROOT/{}_1_20.fastq $ROOT/{}_2_20.fastq {}.contings.skesa.fa"
