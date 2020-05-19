#!/bin/bash

### FEITO POR CIRO BESSA
#

## retira o Taint do master node Kubernete
sudo kubectl taint nodes --all node-role.kubernetes.io/master-

### INSTALACAO DA AWS-CLI v2

# Baixa da AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# move antiga para outro lugar
sudo mv /usr/bin/aws /home/ciro/aws-OLD-BIN-CLI

# Descompacta
unzip awscliv2.zip

# Roda instalacao
 sudo ./aws/install

# gera link no PATH
sudo ln -s /usr/local/bin/aws /usr/bin/aws


### RODA TERRAFORM gerando ambiente ECS-FARGATE na AWS
cd ../terraform-AWS-ECS-deploy

terraform apply -auto-approve


### DESATIVA APLICACOES TERRAFORM e AMBIENTE ECS-FARGATE
terraform destroy -auto-approve 