use strict;
use warnings;

my $seekerData = $ARGV[0];
my $list = $ARGV[1];
my @filenames; #array containing the list of file names (one file per array element)

my @samples; #array containing the samples that have a % greater than 80
my @percentage; #array contianing the percentage of the samples with % greater than 80 (index corresponds to @samples)
my @related; #array containing the most related reference to the samples with % greater than 80 (index corresponds to @samples)
my @samples_lt80; #array containing the samples that have a % less than 80
my @percentage_lt80; #array containing the percentage of the samples with % less than 80 (index corresponding to @samples_lt80)
my @related_lt80; #array containinf the most related reference to the samples with % less than 80 (index corresponds to @samples_lt80)
my %related_species; #hash with the reference as the key and the corresponsing samples as values
my %related_species_lt80; #hash with the reference as key and the corresponsing samples as values (only for those samples with % less than 80)
my @allSamples; #array containing the name of all of the samples (obtaining form a list created with ls SRR* > list.txt)
my $counter = 0; #conter for array assignment


##### 1ST LARGE EDIT
### Here you should add a system call to make the list (it should replace the whole while loop under this
### somehting like this: @allSamples = system(ls SRR*)
### basically make a system call to create a list of the samples
### make sure the list containis the file extension of the strain seeker results (you will remove it later)


#open the file containing the list of samples and store its contents into an array called @allSamples
#this loop will be replaced by the system call above
open(LIST, $list) or die "Could not open $list\n";
while (<LIST>)
{
    chomp $_; #remove end line symbol
    $_ =~ s/\r//g; #remove carriage return
    push @allSamples, $_; #push the sample name into an array
}

##### 2ND LARGE EDIT
### Here you should merge the script called separateSeekerResults.pl in the '/projects/data/reference_DB/genomes/treeGenomes/' directory
### Basically you will want to create six arrays (I know it is dumb, it was just the easiest way to merge everything)
### These are the arrays: @samples, @samples_lt80, @percentage, @percentage_lt80, @related, @related_lt80
### Look at the separateSeekerResults.pl script (the script reads the seeker results files one by one and stores the information into arrays)
### basically you will read the array of the list of samples
### then you will open each file, one by one (strain seeker result files)
### and then check the percentage, if it is greater than 80, then you store the sample name into the @samples array,
### you also store the percentage in the @percentage array, adn the reference into the @related array
### if the percentage is less than 80, then do the same thing but into the _lt80 arrays
### if this requires too much work, then just open the files one by one, and store the sample, percentage, and related into arrays of your choice
### this script would work if you did that
### make sure that when you do all of this, the file extensions are removed in the @samples and @sampels_lt80 arrays

#open the file containing the three columns (of seeker results)
#this loop will be replaced by the merge you will do above
open(SEEKERDATA, $seekerData) or die "Could not open $seekerData\n";
while (<SEEKERDATA>)
{
    chomp $_; #remove end line symbol
    $_ =~ s/\r//g; #remove carriage return
    my @line = split (/\t/,$_); #split the line into an array of three elements called @line

    #if the percentage is greater than 80
    if ($line[1] > 80)
    {
        push @samples, $allSamples[$counter]; #store the sample name in the @samples array
        push @percentage, $line[1]; #store the percent into the @percentage array
        push @related, $line[2]; #srote the reference into the @related array
    }
    else
    {
        push @samples_lt80, $allSamples[$counter]; #srote the sample name into the @samples_lt80 array
        push @percentage_lt80, $line[1]; #store the percentage into the @percentage_lt80 array
        push @related_lt80, $line[2];  #sore the reference into the @related_lt80 array
    }
    $counter+=1; #increase the counter so that the sample name changes each loop iteration
}

##### DO NOT MOVE ANYTHING BELOW THIS
### Make sure that by this point the six important arrays are populated (@sampels, @percentage, @related, and the same but with _lt80)

my $totalSamples = scalar @allSamples; #number of samples
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

#System calls to make the directories and move the trimmed results into those directories
my $a = 'mkdir /projects/data/sra_1_fastq_trimmedFINAL/seeker_result_bins';
system($a);

my $e = 'mkdir /projects/data/sra_1_fastq_trimmedFINAL/seeker_result_bins/less_than_80';
system($e);

foreach my $key (keys %related_species)
{
    my $b = 'mkdir /projects/data/sra_1_fastq_trimmedFINAL/seeker_result_bins/'.$key;
    system($b);
}

for (my $k = 0; $k < $gt80; $k++)
{
    my $c = 'mv /projects/data/sra_1_fastq_trimmedFINAL/'.$samples[$k].' /projects/data/sra_1_fastq_trimmedFINAL/seeker_result_bins/'.$related[$k];
    system($c);
}

foreach my $key (keys %related_species_lt80)
{
    my $f = 'mkdir /projects/data/sra_1_fastq_trimmedFINAL/seeker_result_bins/less_than_80/'.$key;
    system($f);
}

for (my $k = 0; $k < $lt80; $k++)
{
    my $g = 'mv /projects/data/sra_1_fastq_trimmedFINAL/'.$samples_lt80[$k].' /projects/data/sra_1_fastq_trimmedFINAL/seeker_result_bins/less_than_80/'.$related_lt80[$k];
    system($g);
}
