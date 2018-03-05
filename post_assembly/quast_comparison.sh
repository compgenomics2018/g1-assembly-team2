#!/bin/bash

# This script generates quast reports to compare reference and de novo assemblies.
# A separate report per per reference genome is generated

# File structure found in /projects/data/sra_1_fastq_trimmedFINAL/seeker_result_bins
# is assumed as well as folder with skesa assemblies at ../skesa folder

# The std output of this script is a list of assemblies with lower than 95% alignment
# to reference

folders=`ls -d N*`

for folder in $folders; do
	cd $folder
	# Add reference suffix to all fasta files
	ls SRR*.fasta | grep -o [0-9]* | xargs -I{} bash -c 'mv SRR{}.fasta SRR{}_reference.fasta'
	# Copy in skesa de novo assemblies
	ls | grep -o "SRR[0-9]*" | xargs -I{} cp ../../skesa/{}/{}.final.scaffolds.fasta {}_skesa.fasta
	# Run quast
	quast *.fasta -R *.fna -s
	cd ..
done

# Print out low quality assemblies
grep "reference_broken" N*/quast_results/latest/transposed_report.tsv | \
awk 'BEGIN{FS="\t"} {if ($36 < 95) print $1, $36}' |  cut -f4,6 -d_ | \
cut -f2- -d: | sed "s/_broken//"
