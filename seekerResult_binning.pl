use strict;
use warnings;
use Data::Dumper;

my $seekerData = $ARGV[0];
my $list = $ARGV[1];
my @filenames; #array containing the list of file names (one file per array element)

my @samples;
my @percentage;
my @related;
my @samples_lt80;
my @percentage_lt80;
my @related_lt80;
my %related_species;
my %related_species_lt80;
my @allSamples;
my $counter = 0;

open(LIST, $list) or die "Could not open $list\n";
while (<LIST>)
{
    chomp $_; #remove end line symbol
    $_ =~ s/\r//g; #remove carriage return
    push @allSamples, $_;
}

#open the list of file names
open(SEEKERDATA, $seekerData) or die "Could not open $seekerData\n";
while (<SEEKERDATA>)
{
    chomp $_; #remove end line symbol
    $_ =~ s/\r//g; #remove carriage return
    my @line = split (/\t/,$_);

    if ($line[1] > 80)
    {
        push @samples, $allSamples[$counter];
        push @percentage, $line[1];
        push @related, $line[2];
    }
    else
    {
        push @samples_lt80, $allSamples[$counter];
        push @percentage_lt80, $line[1];
        push @related_lt80, $line[2]; 
    }
    $counter+=1;
}

my $totalSamples = scalar @allSamples;
my $gt80 = scalar @samples;
my $lt80 = scalar @samples_lt80;

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
