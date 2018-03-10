#!/usr/bin/python
import os

#Grabs a list of all the references

os.system("ls /projects/data/SCRIPT_TEST/Reference_DB/less_than_80/N* | awk -F '/' '{print $NF}' | sed 's/.txt//' > ./Reference_DB/less_than_80/RefList.txt")
os.system("ls /projects/data/SCRIPT_TEST/Reference_DB/greater_than_80/N* | awk -F '/' '{print $NF}' | sed 's/.txt//' > ./Reference_DB/greater_than_80/RefList.txt")
# Makes RefList.txt for future reference

dirList = ["less_than_80", "greater_than_80"]

for k in range (0, 2):
	directory = dirList[k]
	f = open("/projects/data/SCRIPT_TEST/Reference_DB/"+str(directory)+"/RefList.txt", "r")
	RefList = []
	for line in f:
		RefList.append(line)
	f.close()

	l = len(RefList)

	for i in range (0, l):
		x = RefList[i]
		x = x.rstrip()
		os.system("mkdir ./Reference_DB/"+str(directory)+"/"+str(x))
		# Makes directory for all references in the appropriate confidence score range
		os.system("mv ./Reference_DB/"+str(directory)+"/"+str(x)+".txt ./Reference_DB/"+str(directory)+"/"+str(x)+"/")
		# Moves the text file containing reads mapped to the reference inside its respective folder
		os.system("mkdir ./Reference_DB/"+str(directory)+"/"+str(x)+"/Reference/")
		# Makes a directory for the reference inside of its own folder
		os.system("cp ./RefCombined.py ./Reference_DB/"+str(directory))
		# Copies the assembly script to each folder
		os.system("cp /projects/data/reference_DB/genomes/treeGenomes/"+str(x)+".fna ./Reference_DB/"+str(directory)+"/"+str(x)+"/Reference/")
		# Puts the reference inside of its Reference directory
