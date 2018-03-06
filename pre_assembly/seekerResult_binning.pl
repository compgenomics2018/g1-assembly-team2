use strict;
use warnings;

my @samples; #array containing the samples that have a % greater than 80
my @percentage; #array contianing the percentage of the samples with % greater than 80 (index corresponds to @samples)
my @related; #array containing the most related reference to the samples with % greater than 80 (index corresponds to @samples)
my @samples_lt80; #array containing the samples that have a % less than 80
my @percentage_lt80; #array containing the percentage of the samples with % less than 80 (index corresponding to @samples_lt80)
my @related_lt80; #array containinf the most related reference to the samples with % less than 80 (index corresponds to @samples_lt80)
my %related_species_gt80; #hash with the reference as the key and the corresponsing samples as values
my %related_species_lt80; #hash with the reference as key and the corresponsing samples as values (only for those samples with % less than 80)
my $counter = 0; #conter for array assignment

my @filenames = system('ls SRR* /projects/data/seeker_results_FINAL'); #create an array where each element is the name of one of the seeker result files

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

my $gt80 = scalar @samples; #number of samples with percentages greater than 80
my $lt80 = scalar @samples_lt80; #number of samples with percentages less than 80

#for all samples with percentages greater than 80, store the sample name into its corresponding hash
for (my $j = 0; $j < $gt80; $j++)
{
    if (defined $related_species{$related[$j]})
    {
        push @{$related_species{$related[$j]}}, $samples[$j];
    }
    else
    {
        $related_species{$related[$j]} = [$samples[$j]];
    }  
}

#for all samples with percentages less than 80, store the sample name into its corresponsing hash
for (my $j = 0; $j < $lt80; $j++)
{
    if (defined $related_species_lt80{$related_lt80[$j]})
    {
        push @{$related_species_lt80{$related_lt80[$j]}}, $samples_lt80[$j];
    }
    else
    {
        $related_species_lt80{$related_lt80[$j]} = [$samples_lt80[$j]];
    }
}

#System calls to make the directories and make the trimmed results into those directories
my $a = 'mkdir /reference/seeker_result_bins';
system($a);

my $e = 'mkdir /reference/seeker_result_bins/less_than_80';
system($e);

foreach my $key (keys %related_species_gt80)
{
    my $fh;
    open($fh, "+>", $key); #open the output file
    print $fh values %related_species_gt80{$key}; #print list of samples
}

foreach my $key (keys $related_species_lt80)
{
    my $fh;
    open($fh, "+>", $key); #open the output file
    print $fh values $related_species_lt80{$key}; #print list of samples
}
