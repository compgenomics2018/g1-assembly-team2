import os

os.system("ls S* > FileList.txt")

f = open("FileList.txt", "r")
ReadList = []
for line in f:
	ReadList.append(line)
f.close()



os.system("bowtie2 -build ./Reference/* ./Reference/ref")
os.system("mv ./Reference/* ./")
os.system("cp ./N* ./Reference/")

l = len(ReadList)

for i in range (0, l, 2):
	x = ReadList[i][0:10]
	os.system("bowtie2 -x ref -1 "+str(x)+"_1_20.fastq -2 "+str(x)+"_2_20.fastq --un unmapped."+str(x)" -S "+str(x)+".sam")
