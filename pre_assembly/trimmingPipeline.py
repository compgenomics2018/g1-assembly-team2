import os


f = open("ReadList.txt", "r")
ReadList = []
for line in f:
	ReadList.append(line.rstrip())
f.close()

l = len(ReadList)

for i in range (0, l, 2)
	os.system("trim_galore --illumina -q 20 --clip_R1 20 --clip_R2 20 --three_prime_clip_R1 5 --three_prime_clip_R2 5 --paired /projects/data/sra_1_fastq/"+str(ReadList[i])+" /projects/data/sra_1_fastq/"+str(ReadList[i+1])+" -o /projects/data/temp")
	x = ReadList[i][0:10]
	os.system("sickle pe -q 20 -f /projects/data/temp/"+str(x)+"_1_val_1.fq -r /projects/data/temp/"+str(x)+"_2_val_2.fq -t sanger -o /projects/data/sra_1_fastq_trimmedFINAL/"+str(x)+"_1_20.fastq -p /projects/data/sra_1_fastq_trimmedFINAL/"+str(x)+"_2_20.fastq -s /projects/data/sra_1_fastq_trimmedSINGLE/"+str(x)+"_singles_20.fastq")

os.system("mv ../temp/*trimming* ../sra_1_fastq_trimmedFINAL/")
os.system("rm ../temp/*val*")
