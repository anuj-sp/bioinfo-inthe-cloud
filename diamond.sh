#! /usr/bin/env bash 

#set -euxo pipefail 

type=$1 # protein 
queryfiletype=$2 # 1 for .fa file, 2 for .txt of refseq sequences 
queryfile=$3 # .fa file or .txt file 
databasefiletype=$4 # 0 for predetermined database, 1 for custom database from .fa files, 2 for database from refseq ids 
databasefile=$5 # if 0 then name of database, 1 then .fa file, 2 then .txt file 
output=$6

# Create directories for analysis
rm -rf blastdb queries fasta results blastdb_custom
mkdir -p blastdb queries fasta results blastdb_custom

# Retrieve query sequences
if [ "${queryfiletype}" = "2" ]; then 
	query_ids="$(cat ${queryfile})"
	docker run --rm ncbi/blast efetch -db ${type} -format fasta -id ${query_ids} > queries/queries.fsa
	queryfile=queries.fsa
elif [ "${queryfiletype}" = 1 ]; then 
	mv ${queryfile} queries/${queryfile}
fi 

# Database file type (0 if using predetermined database or 1 for custom database using FASTA format or 2 for custom databse with RefSeq IDs)
if [ "${databasefiletype}" -eq 2 ]; then 
	db_ids="$(cat ${databasefile})"
	docker run --rm ncbi/blast efetch -db ${type} -format fasta -id $db_ids > fasta/database.fsa
	diamond makedb --in fasta/database.fsa -d blastdb_custom/database
	db=blastdb_custom/database
elif [ "${databasefiletype}" -eq 1 ]; then 
	cp ${databasefile} fasta/${databasefile}
	diamond makedb --in fasta/${databasefile} -d blastdb_custom/database
 	db=blastdb_custom/database
else 
	docker run --rm -v $HOME/blastdb:/blast/blastdb:rw -w /blast/blastdb ncbi/blast update_blastdb.pl --source gcp ${databasefile}
	tempdb=${databasefile}
	docker run --rm -v $HOME/blastdb:/blast/blastdb:rw -v $HOME/fasta:/blast/fasta:rw ncbi/blast blastdbcmd -entry all -db $tempdb -out fasta/database.fsa -outfmt %f
	diamond makedb --in fasta/database.fsa -d blastdb_custom/database
	db=blastdb_custom/database
fi

# Run Diamond 
if [ "${type}" = "protein" ]; then
	diamond blastp -d blastdb_custom/database -q queries/${queryfile} -o results/${output}.xml -f 5 
fi 
