#!/bin/bash


### INSTALA TERRAFORM
##

sudo apt-get nstall -y wget
sudo apt-get install -y unzip

wget https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip

unzip terraform_0.12.25_linux_amd64.zip

sudo cp terraform /usr/bin

./terraform init 
 

