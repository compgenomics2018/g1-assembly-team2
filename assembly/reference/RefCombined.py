import os

f = open("RefList.txt", "r")
RefList = []
for line in f:
	RefList.append(line)
f.close()

l = len(RefList)

for i in range (0, l):
	x = RefList[i]
	x = x.rstrip()
	os.system("bowtie2-build ./"+str(x)+"/Reference/*.fna ./"+str(x)+"/Reference/ref")
	# Builds the reference in each folder and names it "ref"
	os.system("mv ./"+str(x)+"/Reference/* ./"+str(x)+"/")
	# Moves files outside of Reference folder
	os.system("cp ./"+str(x)+"/*.fna ./"+str(x)+"/Reference/")
	# Copies fna of reference back in to Reference folder for ease of reference
	ReadList = open("./"+str(x)+"/"+str(x)+".txt").read().split()
	# # Opens list containing reads 
	k = len(ReadList)
	for j in range (0, k):
		y = ReadList[j][0:10]
		print "1"
		os.system("bowtie2 -x ./"+str(x)+"/ref -1 /projects/data/SCRIPT_TEST/"+str(y)+"_1.fastq -2 /projects/data/SCRIPT_TEST/"+str(y)+"_2.fastq --un ./"+str(x)+"/unmapped."+str(y)+" -S ./"+str(x)+"/"+str(y)+".sam")
		# Runs bowtie alignment /projects/data/SCRIPTS_TEST should be changed to directory with trimmed reads inside
		print "2"
		os.system("samtools view -bS ./"+str(x)+"/"+str(y)+".sam > ./"+str(x)+"/"+str(y)+".bam")
		# Converts sam to bam
		print "3"
		os.system("samtools sort -o ./"+str(x)+"/"+str(y)+"_sorted.bam ./"+str(x)+"/"+str(y)+".bam")
		print "4"
		# Sorts bam file
		os.system("samtools index ./"+str(x)+"/"+str(y)+"_sorted.bam")
		print "5"
		# Indexes sorted bam file
		os.system("bam2fastq --no-aligned --strict --force -o ./"+str(x)+"/unmapped"+str(y)+"#.fastq ./"+str(x)+"/"+str(y)+"_sorted.bam")
		print "6"
		# Converst bam to fastq
		os.system("samtools mpileup -f ./"+str(x)+"/Reference/*.fna -gu ./"+str(x)+"/"+str(y)+"_sorted.bam | bcftools call -c -O b -o ./"+str(x)+"/"+str(y)+".raw.bcf")
		print "7"
		# Calls SNPs/indels between reference and query
		os.system("bcftools view -O v ./"+str(x)+"/"+str(y)+".raw.bcf | vcfutils.pl vcf2fq > ./"+str(x)+"/"+str(y)+".fastq")
		print "8"
		# Converts variant called files to fastq
		os.system("seqret -sequence ./"+str(x)+"/"+str(y)+".fastq -outseq ./"+str(x)+"/"+str(y)+".fasta")
		print "9"
		# Converts query fastq to fasta
		os.system("rm ./"+str(x)+"/"+str(y)+"*.bam*")
		os.system("rm ./"+str(x)+"/"+str(y)+".fastq")
		os.system("rm ./"+str(x)+"/"+str(y)+"*raw.bcf")
		# Cleans the directory
