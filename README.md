# NCBI BLAST+ and DIAMOND in Google Cloud 

## Installation 

## Prerequities 
* Google cloud SDK, 
* Google cloud ```ssh``` & ```scp``` enabled 
* Private and Public ssh key for Google cloud enabled. 
* Google cloud Linux virtual machine 

Usage: ./alignment.sh [options]

Compulsory Arguments: 
1. Query file type (i.e. 1 for sequence files in FASTA format or 2 for list of RefSeq IDs in .txt file)
2. Query sequence in FASTA format (.fa file)
3. Database file type (0 if using predetermined database or 1 for custom database using FASTA format or 2 for custom database with RefSeq IDs)
4. Database file (0 if using predetermined database or .fa FASTA file or .txt RefSeq ID file)
5. Google cloud virtual machine instance name 
6. Sequence alignment program to use (0 for BLAST and 1 for Diamond)
7. External ip address to allow for ssh into Google cloud instance
8. ssh key to allow for ssh into Google cloud instance
9. Username to allow for ssh into Google cloud instance 
10. Output file name. The output file will be placed in the current working directory. 

Ensure arguments are placed in the same order as mentioned above. 
