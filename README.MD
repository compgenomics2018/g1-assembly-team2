# Genome Assembly

This repository contains a set of genome assembly scripts for Team II's genome assembly group. 

For general info, see the [project's wiki page](http://www.compgenomics2018.biosci.gatech.edu/Team_II_Genome_Assembly_Group).

## File Structure and Usage

The repository is organized as follows:

    .
    ├── assembler.sh            # Final assembly pipeline
    ├── pre_assebly             # A set of pre-assembly (quality control) scripts
    ├── assembly                # A set of scripts for the actual genome assembly
    │   ├── de_novo             # De novo assembly scripts
    │   ├── reference           # Reference assembly scripts
    ├── post_assembly           # A set of post-assembly scripts
    └

For information how to use the final assembly pipeline, run

    ./assembler.sh -h

The remaining folders contain individual scripts which are not necessarily included in the final pipeline. Some of these scripts **might only work on** `biogenome2018b.biology.gatech.edu` server since they rely on specific files present on this server.
