# Genome Assembly

This repository contains a set of genome assembly scripts for Team II's genome assembly group. 

For general info, see the [project's wiki page](http://www.compgenomics2018.biosci.gatech.edu/Team_II_Genome_Assembly_Group).

## File Structure and Usage

The repository is organized as follows:

    .
    ├── final_pipeline.sh       # Final assembly pipeline
    ├── de_novo.sh              # Pipeline just for de novo assembly
    ├── pre_assebly             # A set of pre-assembly (quality control) scripts
    ├── assembly                # A set of scripts for the actual genome assembly
    │   ├── de_novo             # De novo assembly scripts
    │   ├── reference           # Reference assembly scripts
    ├── post_assembly           # A set of post-assembly scripts
    └

To assemble a genome, run

    ./final_pipeline -a forward_reads.fastq -b reverse_reads.fastq -o assembly.fasta

To display additional options, run

    ./final_pipeline -h

The remaining folders contain individual scripts which are not necessarily included in the final pipeline. Some of these scripts **might only work on** `biogenome2018b.biology.gatech.edu` server since they rely on specific files present on this server.

## Installation & Dependencies

No installation is needed, only thing required is to clone the repository and run the `final_pipeline.sh` script.

However, several dependencies are assumed in the path:

* **Trimming**
	* [TrimGalore](https://github.com/FelixKrueger/TrimGalore)
		* [Cutadapt](https://github.com/marcelm/cutadapt)
		* [FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
	* [Sickle](https://github.com/najoshi/sickle)
* **De Novo**
	* Skesa  (Not open sourced yet)
	* [SSPACE Standard](https://vcru.wisc.edu/simonlab/bioinformatics/programs/install/sspace.htm)
		* The installation of SSPACE is a little tricky, SSPACE folder needs to be in your path. Please follow the [official installation instructions.](https://vcru.wisc.edu/simonlab/bioinformatics/programs/install/sspace.htm)
		* On the server, this means adding `PATH="$PATH:/projects/data/bin/SSPACE"` to your .bashrc/profile etc.
* **Reference** (Currently in development)
	* [Bowtie2](https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.1)
	* [Samtools](https://github.com/samtools/)
	* [Bcfools](https://github.com/samtools/bcftools)
	* [EMBOSS Seqret](http://emboss.sourceforge.net/apps/release/6.6/emboss/apps/seqret.html)
	* [GenomeTester4](https://github.com/bioinfo-ut/GenomeTester4)
	
A description of each of these tools is available in the [project's wiki](http://www.compgenomics2018.biosci.gatech.edu/Team_II_Genome_Assembly_Group).
