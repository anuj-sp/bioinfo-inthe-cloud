#! /usr/bin/bash 

if [ -x "$(command -v diamond)" ]; then 
	echo "Diamond exists"
else 
	wget http://github.com/bbuchfink/diamond/releases/download/v0.9.28/diamond-linux64.tar.gz
	tar xzf diamond-linux64.tar.gz
	sudo mv diamond /usr/bin
fi 
if [ -x "$(command -v docker)" ]; then
    echo "Docker exists"
    sudo service docker restart 
else
    sudo snap install docker
	sudo apt update
	sudo apt install -y docker.io
	sudo usermod -aG docker $USER
fi
if [[ "$(docker images -q ncbi/blast:latest 2> /dev/null)" == "" ]]; then
	docker pull ncbi/blast 
fi 