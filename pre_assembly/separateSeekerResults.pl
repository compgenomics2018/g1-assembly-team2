use strict;
use warnings;

my $list = $ARGV[0]; #txt file with a list of the file names
my $outfile = $ARGV[1]; #file name of the output
my @filenames; #array containing the list of file names (one file per array element)

open(OUT, "+>", $outfile); #open the output file

#open the list of file names
open(FILELIST, $list) or die "Could not open $list\n";
while (<FILELIST>)
{
    chomp $_; #remove end line symbol
    $_ =~ s/\r//g; #remove carriage return

    push @filenames, $_; #name array of filenames (one file per array element)
}

my $number_of_files = scalar @filenames; #store the number of files in list

#open every file, one by one
for (my $i; $i <= $number_of_files; $i++)
{
    my $sample = $filenames[$i]; #store the sample name
    my $percentage;
    my $relatedList;
    my $reference_species;

    open(FILE, $filenames[$i]) or die "Could not open $filenames[$i]\n";
    while (<FILE>)
    {
        chomp $_; #remove end line symbol
        $_ =~ s/\r//g; #remove carriage return just in case
        my @line = split (/\s/,$_); #create array of percentage \t 'RELATED' \t list of related species

        $percentage = chomp $line[0]; #keep the percentage (remove '%' symbol)
        $relatedList = $line[2]; #keep the lsit of related species
    }

    #if the percentage is above 0% then store the first 'related' species
    if ($relatedList =~ m/,/)
    {
        my @reference = split (/,/,$relatedList); #split comma separated list
        $reference_species = $reference[0]; #keep the first element of the list, aka the most related species
    }
    else
    {
	$reference_species = $relatedList; #if there is just one element in the list then just make that element equal to $reference_species
    }

    print OUT "$sample\t$percentage\t$reference_species\n"; #print out the sample name, percentage, and the reference species it is most related to
}
