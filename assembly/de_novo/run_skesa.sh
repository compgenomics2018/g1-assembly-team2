#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
	>&2 echo "Error: Incorrect number of arguments."
    >&2 echo "Usage: $0 FORWARD_READS REVERSE_READS OUTPUT_FILE"
    exit 1
fi

skesa --fastq $1,$2 --use_paired_ends > $3
