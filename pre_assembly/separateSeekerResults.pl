use strict;
use warnings;

my $list = $ARGV[0]; #txt file with a list of the file names
my $outfile = $ARGV[1]; #file name of the output

my @samples_all; #array containing all of the samples
my @percentage_all; #array contianing the percentage of all of the samples
my @related_all; #array containing the most related reference to each of the samples

open(OUT, "+>", $outfile); #open the output file

my @filenames = system(ls SRR* /projects/data/seeker_results_FINAL);

my $number_of_files = scalar @filenames; #store the number of files in list

#open every file, one by one
for (my $i = 0; $i < $number_of_files; $i++)
{
    my $percentage;
    my $relatedList;
    my $reference_species;
    my $sample = $filenames[$i];
    $sample =~ s/_[12]_20.fastq_seeker_run//g;

    open(FILE, $filenames[$i]) or die "Could not open $filenames[$i]\n";
    my $temp = <FILE>; #skip first line
    while (<FILE>)
    {
        chomp $_; #remove end line symbol
        $_ =~ s/\r//g; #remove carriage return just in case
        my @line = split (/\s/,$_); #create array of percentage \t 'RELATED' \t list of related species

        $percentage = chomp $line[0]; #keep the percentage (remove '%' symbol)
        $relatedList = $line[2]; #keep the lsit of related species
    }

    #if the percentage is above 80% then store the first 'related' species
    if ($relatedList =~ m/,/)
    {
        my @reference = split (/,/,$relatedList); #split comma separated list
        $reference_species = $reference[0]; #keep the first element of the list, aka the most related species
    }
    else
    {
       $reference_species = $relatedList; #if there is just one element in the list then just make that element equal to $reference_species
    }

    if ($percentage >= 80)
    {
        push @samples, $sample; #store the sample name in the @samples array
        push @percentage, $percentage; #store the percent into the @percentage array
        push @related, $reference_species; #srote the reference into the @related array
    }
    elsif ($percentage < 80)
    {
        push @samples_lt80, $sample; #store the sample name into the @samples_lt80 array
        push @percentage_lt80, $percentage; #store the percentage into the @percentage_lt80 array
        push @related_lt80, $reference_species;  #store the reference into the @related_lt80 array
    }
}
