#!usr/bin/perl -w

use strict;
#path to a text file containing list of the fastq paired end reads
my $L= '/projects/data/scripts/sra_list_20.txt';
unless (open(FILE,$L)){print "cannot open the list of files to be scaffolded"};
my $i=0;
my @lines;

@lines=<FILE>;
close FILE;

while ($i<scalar(@lines)){
    my $filename=substr($lines[$i],0,10);
        chomp $lines[$i];
        chomp $lines[$i+1];
        
        #making lib files for use in SSPACE tool: libname alignment_tool fastq.1 fastq.2 insert_size error direction_of_reads
        unless (open OUT,">lib_$filename.txt"){ print "Unable to open library file"};  
        print OUT "lib1 bowtie /projects/data/sra_1_fastq_trimmedFINAL/$lines[$i] /projects/data/sra_1_fastq_trimmedFINAL/$lines[$i+1] 200 0.99 FR";
        close OUT;    
       
        system("sed -i 's/  */ /g' lib_$filename.txt "); 

        #sspace usage: sspace.pl libfile contig_file basename 
        system("/projects/data/bin/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl -l /projects/data/scaffolds/skesa/ALL_20_/lib_$filename.txt -s /projects/data/assemblies/skesa/ALL_20/$filename.contings.skesa.fa -b $filename -x 1 -p 1");
      #   system ("find . \( -name "alignoutput" -o -name "intermediate_results" -o -name "pairinfo" \) -exec rm -r \"{}\" + ");
$i=$i+2;
}
