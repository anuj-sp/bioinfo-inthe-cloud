#!/usr/bin/env bash 

# set -euxo pipefail

type=$1 # protein 
queryfiletype=$2 # 1 for .fa file, 2 for .txt of refseq sequences 
queryfile=$3 # .fa file or .txt file 
databasefiletype=$4 # 0 for predetermined database, 1 for custom database from .fa files, 2 for database from refseq ids 
databasefile=$5 # if 0 then name of database, 1 then .fa file, 2 then .txt file 
output=$6

# Create directories for analysis
rm -rf blastdb queries fasta results blastdb_custom
mkdir -p blastdb queries fasta results blastdb_custom
# sudo service docker restart 

if [ "${queryfiletype}" = "2" ]; then 
	query_ids="$(cat ${queryfile})"
	docker run --rm ncbi/blast efetch -db ${type} -format fasta -id $query_ids > queries/queries.fsa
	queryfile=queries.fsa
elif [ "${queryfiletype}" = "1" ]; then 
	mv ${queryfile} queries/${queryfile}
fi

# Database file type (0 if using predetermined database or 1 for custom database using FASTA format or 2 for custom databse with RefSeq IDs)

if [ "${databasefiletype}" = "2" ]; then 
	db_ids="$(cat ${databasefile})"
	docker run --rm ncbi/blast efetch -db ${type} -format fasta -id $db_ids > fasta/database.fsa
	docker run --rm -v $HOME/blastdb_custom:/blast/blastdb_custom:rw -v $HOME/fasta:/blast/fasta:ro  -w /blast/blastdb_custom ncbi/blast makeblastdb -in /blast/fasta/database.fsa -dbtype prot -parse_seqids -blastdb_version 5 -out database 
 	db=database
elif [ "${databasefiletype}" = "1" ]; then 
	mv ${databasefile} fasta/${databasefile}
	docker run --rm -v $HOME/blastdb_custom:/blast/blastdb_custom:rw -v $HOME/fasta:/blast/fasta:ro  -w /blast/blastdb_custom ncbi/blast makeblastdb -in /blast/fasta/${databasefile} -dbtype prot -parse_seqids -blastdb_version 5 -out database 
 	db=database
else 
	docker run --rm -v $HOME/blastdb:/blast/blastdb:rw -w /blast/blastdb ncbi/blast update_blastdb.pl --source gcp ${databasefile}
	db=${databasefile}
fi

# Run BLAST 

if [ "${type}" = "protein" ]; then 
	docker run --rm -v $HOME/blastdb:/blast/blastdb:ro -v $HOME/blastdb_custom:/blast/blastdb_custom:ro -v $HOME/queries:/blast/queries:ro -v $HOME/results:/blast/results:rw ncbi/blast blastp -query /blast/queries/${queryfile} -db ${db} -out /blast/results/${output}.out
fi 
