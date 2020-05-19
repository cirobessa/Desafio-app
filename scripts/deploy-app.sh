#!/bin/bash

### FEITO POR CIRO BESSA
#

### Garantindo a especificação das Availability zone AWS
export AWS_DEFAULT_REGION='us-east-1'
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



### SOBE APP PARA O ECR
cd app
cp ../terraform-AWS-ECS-deploy/cria-repo.tf  .
terraform init
terraform plan
terraform apply -auto-approve

###  Faz o Login no ECR para upload do app
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 874001116236.dkr.ecr.us-east-1.amazonaws.com

## prepara o Build local para o Repositiro ECR
docker build -t cb-counter .


### Configura TAGs obrigatorias da Image
docker tag cb-counter:latest 874001116236.dkr.ecr.us-east-1.amazonaws.com/cb-counter:latest


### Faz o push do image para o Repositorio ECR
docker push 874001116236.dkr.ecr.us-east-1.amazonaws.com/cb-counter:latest




### RODA TERRAFORM gerando ambiente ECS-FARGATE na AWS
cd ../terraform-AWS-ECS-deploy
terraform init
terraform plan -out plano
 terraform apply "plano"



### DESATIVA APLICACOES TERRAFORM e AMBIENTE ECS-FARGATE
terraform destroy -auto-approve 