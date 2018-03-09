#!/bin/bash
################################################################################################################

reference_assembly=0
de_novo=0
reads_pair1=""
reads_pair2=""
output=""

usage() { echo "Usage: filename.sh -a <fastq_reads_pair1> -b <fastq_reads_pair2> -o <output filename> [-t Phred q score threshold ] [-r reference assembly] [-d de novo assembly] [-h help] " ; exit 1; }

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
    
    t) phred_quality_threshold=$OPTARG 
       if [[ ! -e "$phred_quality_threshold" ]]; then          
        phred_quality_threshold=20;
        fi
       ;;
    
    
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

##############################################################################################################################
#trimming
#trim_galore takes in paired end .fq files and removes adapters
trim_galore --illumina --paired $reads_pair1 $reads_pair2 -o /projects/data/temp

echo ${reads_pair1:0:10} 

#sickle trims according to a quality threshold and uses a sliding window
sickle pe -q $phred_quality_threshold -f /projects/data/temp/${reads_pair1:0:10}_1_val_1.fq -r /projects/data/temp/${reads_pair1:0:10}_2_val_2.fq -t sanger -o /projects/data/sra_1_fastq_trimmedFINAL/${reads_pair1:0:10}_1_20.fastq -p /projects/data/sra_1_fastq_trimmedFINAL/${reads_pair1:0:10}_2_20.fastq -s /projects/data/sra_1_fastq_trimmedSINGLE/${reads_pair1:0:10}_singles_20.fastq
#mv ../temp/*_1_20.fastq ../sra_1_fastq_trimmedFINAL/
#mv ../temp/*_2_20.fastq ../sra_1_fastq_trimmedFINAL/
#rm ../temp/*val*
#rm ../sra_1_fastq_trimmedFINAL/*singles*


################################################################################################################################

if [[ $reference_assembly -eq 1 ]]; then                   
  echo "Please use the standalone reference assembly script in /assembly/reference or use de novo assembly. It will be added to the pipeline soon"        
  exit 1;
else
  de_novo=1
fi

###########################################################################################################################

if [[ $de_novo -eq 1 ]]; then
    de_novo.sh /projects/data/sra_1_fastq_trimmedFINAL/${reads_pair1:0:10}_1_20.fastq /projects/data/sra_1_fastq_trimmedFINAL/SRR5666515_2_20.fastq $output
else
    echo "Reference Assembly"
fi

exit 1;
