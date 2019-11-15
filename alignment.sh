#! /usr/bin/env bash

#set -euxo pipefail 

export LC_ALL=C

Usage() {
    cat <<EOF

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

Ensure they are placed in the same order as mentioned. 

EOF
    exit 1
}

#[ "$1" = "" ] && Usage 

TYPE="protein" 
QUERYFILETYPE=$1
QUERY=$2
DATABASEFILETYPE=$3
DATABASEFILE=$4
INSTANCE=$5
PROGRAM=$6
EXTERNALIP=$7
SSHKEY=$8
USERNAME=$9
OUTPUT=${10}

ssh -i ${SSHKEY} ${USERNAME}@${EXTERNALIP} "bash -s" < setup.sh 
gcloud compute scp ${QUERY} ${INSTANCE}:~/
if [ "${DATABASEFILETYPE}" -gt 0 ]; then 
    gcloud compute scp ${DATABASEFILE} ${INSTANCE}:~/
fi 

if [ ${PROGRAM} -eq 0 ]; then 
    ssh -i ${SSHKEY} ${USERNAME}@${EXTERNALIP} "bash -s" < ./blast.sh "${TYPE}" "${QUERYFILETYPE}" "${QUERY}" "${DATABASEFILETYPE}" "${DATABASEFILE}" "${OUTPUT}"
	gcloud compute scp ${INSTANCE}:~/results/${OUTPUT}.out ${PWD}
else 
    ssh -i ${SSHKEY} ${USERNAME}@${EXTERNALIP} "bash -s" < ./diamond.sh "${TYPE}" "${QUERYFILETYPE}" "${QUERY}" "${DATABASEFILETYPE}" "${DATABASEFILE}" "${OUTPUT}"
    gcloud compute scp ${INSTANCE}:~/results/${OUTPUT}.xml ${PWD}
fi 