#!/bin/bash
################################################################################################################

reference_assembly=0
de_novo=0
reads_pair1=""
reads_pair2=""
output=""
phred_quality_threshold=20
usage() { echo "Usage: filename.sh -a <fastq_reads_pair1.fastq> -b <fastq_reads_pair2.fastq> -o <output filename> [-t Phred q score threshold ] [-h help] " ; exit 1; }

while getopts a:b:rdo:ht: ARGS; do
  case $ARGS in   
    
    a) reads_pair1=$OPTARG
        if [[ ! -e "$reads_pair1" ]]; then          
        echo "fastq_reads_pair1 does not exist"; exit 1;
        fi
        ;;
    
    b) reads_pair2=$OPTARG
        if [[ ! -e "$reads_pair2" ]]; then          
        echo "fastq_reads_pair2 does not exist"; exit 1;
        fi
        ;;
    
    r) reference_assembly=1 ;;
    
    d) de_novo=1 ;;
    
    o) output=$OPTARG                           
         if [[ -e "$output" ]]; then
         echo "The output file name exists"             
         echo "type "Y" if you want to overwrite"      
         echo "type "N" if you want to exit"            
         read input;                                   
         case $input in
               Y|y) output=$OPTARG ;;           
               N|n) exit 1; ;;
          esac      
       fi
       ;;
    
    t) phred_quality_threshold=$OPTARG ;;
    
    
    *|h) usage ;;
    
    
    
esac   
done

if [[ -z $reads_pair1 ]]; then
  echo "Please specify file with forward reads"
  usage
  exit 1
fi

if [[ -z $reads_pair2 ]]; then
  echo "Please specify file with reverse reads"
  usage
  exit 1
fi

if [[ -z $output ]]; then
  echo "Please specify output file"
  usage
  exit 1
fi

if [[ $reference_assembly -eq 1 && $de_novo -eq 1 ]]; then
    echo "Please choose either reference or de novo assembly" ;exit 1;
fi

#trimming
#trim_galore takes in paired end .fq files and removes adapters
trim_galore --illumina --paired $reads_pair1 $reads_pair2 -o .

# this is what trimgalore output files look like. File .fastq or .fq file format of input files is assumed
trimOut1=`echo $reads_pair1 | sed -e "s/\.[^.]*$/_val_1.fq/" | awk -F/ '{print $NF}'`
trimOut2=`echo $reads_pair2 | sed -e "s/\.[^.]*$/_val_2.fq/" | awk -F/ '{print $NF}'`
rm *_trimming_report.txt


sickleOut1=`echo $reads_pair1 | sed -e "s/\.[^.]*$/_sickle_1.fq/" | awk -F/ '{print $NF}'`
sickleOut2=`echo $reads_pair2 | sed -e "s/\.[^.]*$/_sickle_2.fq/" | awk -F/ '{print $NF}'`

# Sickle trims according to a quality threshold and uses a sliding window
sickle pe -q $phred_quality_threshold -f $trimOut1 -r $trimOut2 -t sanger -o $sickleOut1 -p $sickleOut2 -s singles.fastq

rm singles.fastq
rm $trimOut1
rm $trimOut2


if [[ $reference_assembly -eq 1 ]]; then                   
  echo "This option is not fully supported yet. Plese use the de novo assembly."
  exit 1;
fi


de_novo.sh $sickleOut1 $sickleOut2 $output

rm $sickleOut1
rm $sickleOut2
