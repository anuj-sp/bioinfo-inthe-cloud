#! /usr/bin/env bash

#set -euxo pipefail 

export LC_ALL=C

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
