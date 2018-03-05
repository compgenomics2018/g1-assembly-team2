import os

f = open("FileList.txt", "r")
ReadList = []
for line in f:
	ReadList.append(line)
f.close()

l = len(ReadList)

for i in range (0, l, 2):
	x = ReadList[i][0:10]
	os.system("samtools view -bS ./"+str(x)+".sam > ./"+str(x)+".bam")
	os.system("samtools sort -o ./"+str(x)+"_sorted.bam ./"+str(x)+".bam")
	os.system("samtools index ./"+str(x)+"_sorted.bam")
	os.system("bam2fastq --no-aligned --strict --force -o ./unmapped"+str(x)+"#.fastq ./"+str(x)+"_sorted.bam")
	os.system("samtools mpileup -f ./Reference/N* -gu ./"+str(x)+"_sorted.bam | bcftools call -c -O b -o ./"+str(x)+".raw.bcf")
	os.system("bcftools view -O v ./"+str(x)+".raw.bcf | vcfutils.pl vcf2fq > ./"+str(x)+".fastq")
	os.system("seqret -sequence ./"+str(x)+".fastq -outseq ./"+str(x)+".fasta")
	os.system("rm ./"+str(x)+".bam*")
	os.system("rm ./"+str(x)+".fastq")
	os.system("rm ./"+str(x)+"raw.bcf")
	os.system("rm ./*unmapped*")
