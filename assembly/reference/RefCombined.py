import os

os.system("ls SRR* > FileList.txt")

f = open("FileList.txt", "r")
ReadList = []
for line in f:
	ReadList.append(line)
f.close()


os.system("bowtie2 -build ./Reference/* ./Reference/ref")
os.system("mv ./Reference/* ./")
os.system("cp ./*.fna ./Reference/")

l = len(ReadList)

for i in range (0, l, 2):
	x = ReadList[i][0:10]
	os.system("bowtie2 -x ref -1 "+str(x)+"_1_20.fastq -2 "+str(x)+"_2_20.fastq --un unmapped."+str(x)" -S "+str(x)+".sam")

for i in range (0, l, 2):
	x = ReadList[i][0:10]
	os.system("samtools view -bS ./"+str(x)+".sam > ./"+str(x)+".bam")
	os.system("samtools sort -o ./"+str(x)+"_sorted.bam ./"+str(x)+".bam")
	os.system("samtools index ./"+str(x)+"_sorted.bam")
	os.system("bam2fastq --no-aligned --strict --force -o ./unmapped"+str(x)+"#.fastq ./"+str(x)+"_sorted.bam")
	os.system("samtools mpileup -f ./Reference/*.fna -gu ./"+str(x)+"_sorted.bam | bcftools call -c -O b -o ./"+str(x)+".raw.bcf")
	os.system("bcftools view -O v ./"+str(x)+".raw.bcf | vcfutils.pl vcf2fq > ./"+str(x)+".fastq")
	os.system("seqret -sequence ./"+str(x)+".fastq -outseq ./"+str(x)+".fasta")
	os.system("rm ./"+str(x)+".bam*")
	os.system("rm ./"+str(x)+".fastq")
	os.system("rm ./"+str(x)+"raw.bcf")
