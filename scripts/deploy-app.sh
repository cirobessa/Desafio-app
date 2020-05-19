#!/bin/bash



######### FAZ deploy do APP DE CONTAGEM no Cluster Kubernetes LOCAL & na NUVEM AWS,
######### usando a mesma image docker do App.

### FEITO POR CIRO BESSA
#



######## SESSAO KUBERNETES ONPREMISSES + TERRAFORM
###  
## retira o Taint do master node Kubernete
sudo kubectl taint nodes --all node-role.kubernetes.io/master-

### Faz o Build da image no docker
 cd app/
sudo docker build . -t cirobessa/counter.js


### Roda o terraform para realizar o teste e Deploy do app
cd ../terraform-kubernetes-deploy/
terraform init 
terraform plan
terraform apply -auto-approve


### Acessar o APP RODANDO e contando cada nova visita
curl localhost:30201
curl localhost:30201
curl localhost:30201

### Pelo Terraform, faz o destroy e o re-apply do APP
terraform destroy  -auto-approve 
terraform plan
terraform apply -auto-approve


### Acessar novamente o APP RODANDO e contando cada nova visita
curl localhost:30201
curl localhost:30201
curl localhost:30201

cd ..
##### FIM DO KUBERNETES ON-PREMISSES



##############################################
############### SESSAO AWS + TERRAFORM
### Garantindo a especificação das Availability zone AWS
export AWS_DEFAULT_REGION='us-east-1'


### INSTALACAO DA AWS-CLI v2

# Baixa da AWS
mkdir tmp
cd tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# move antiga para outro lugar
sudo mv /usr/bin/aws /home/ciro/aws-OLD-BIN-CLI

# Descompacta
unzip awscliv2.zip

# Roda instalacao
 sudo ./aws/install

# gera link no PATH
sudo ln -s /usr/local/bin/aws /usr/bin/aws


## CONFIGURA Credenciais do AWSCLI
aws configure
cd ..


### SOBE APP PARA O ECR

cd terraform-AWS-ECS-deploy/repo-ECR/
terraform init
terraform plan
terraform apply -auto-approve


###  Faz o Login no ECR para upload do app
cd ../app
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 874001116236.dkr.ecr.us-east-1.amazonaws.com

## prepara o Build local para o Repositiro ECR
docker build -t cb-counter .


### Configura TAGs obrigatorias da Image
docker tag cb-counter:latest 874001116236.dkr.ecr.us-east-1.amazonaws.com/cb-counter:latest


### Faz o push do image para o Repositorio ECR
docker push 874001116236.dkr.ecr.us-east-1.amazonaws.com/cb-counter:latest
docker push 874001116236.dkr.ecr.us-east-1.amazonaws.com/cb-counter:latest


### RODA TERRAFORM gerando ambiente ECS-FARGATE na AWS
cd ../terraform-AWS-ECS-deploy/ECS-fargate/

terraform init
terraform plan -out plano
 terraform apply "plano"



### DESATIVA APLICACOES TERRAFORM e AMBIENTE ECS-FARGATE
terraform destroy -auto-approve 


### FIM DEPLOys

