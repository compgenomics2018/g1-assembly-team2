#/bin/bash

# A script to assemble unmapped reads in all bins coming from reference assembly
# Must be placed in the root assembly folder to work properly

folders=`ls | grep N._*`

for folder in $folders; do
	cd $folder
	ls SRR*.fasta | grep -o [0-9]* | xargs -I{} bash -c 'skesa --fastq unmappedSRR{}_1.fastq,unmappedSRR{}_2.fastq --use_paired_ends > unmapped_SRR{}.fasta'
	cd ..
done
