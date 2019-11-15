# NCBI BLAST+ and DIAMOND in Google Cloud 

Pre requisites: 
Google Cloud SDK, 
Google Cloud ssh & scp enabled 
Private and Public ssh key for google cloud enabled. 

Usage: ./alignment.sh [options]

Compulsory Arguments: 
Query file type (i.e. 1 for sequence files in FASTA format or 2 for list of RefSeq IDs in .txt file)
Query sequence in FASTA format (.fa file)
Database file type (0 if using predetermined database or 1 for custom database using FASTA format or 2 for custom database with RefSeq IDs)
Database file (0 if using predetermined database or .fa FASTA file or .txt RefSeq ID file)
Google cloud virtual machine instance name 
Sequence alignment program to use (0 for BLAST and 1 for Diamond)
External ip address to allow for ssh into Google cloud instance
ssh key to allow for ssh into Google cloud instance
Username to allow for ssh into Google cloud instance 
Output file name. The output file will be placed in the current working directory. 

Ensure arguments are placed in the same order as mentioned above. 
