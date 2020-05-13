#!/bin/bash

### Instala, configura e faz Deploy de aplicacao com ....
#  Docker, Kubernetes, Ansible, App em Node.JS, etc. ainda em construção

# montado por CIro Bessa

# Material de APoio:
#  https://kubernetes.io/docs
#  https://kodekloud.com
#   https://docs.docker.com/
#  https://hub.docker.com/
#  https://www.udemy.com/
#  https://stackoverflow.com
#  E varios canais de youtube
#

##### KUBERNETES  - single Host  


echo "==================
 SESSAO Dependencias
====================="
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get python -y
sudo apt-get python3 -y
sudo apt-get python-pip -y
sudo apt-get python-pip3  -y
sudo apt-get install sl curl -y
sudo apt-get install apt-transport-https -y
sudo apt install net-tools -y
sudo apt install ca-certificates gnupg-agent software-properties-common -y



# ensure legacy binaries are installed
sudo apt-get install -y iptables arptables ebtables

# switch to legacy versions
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy
 



echo "==================
 SESSAO DOCKER
====================="


./install-docker.sh



echo "==================
 SESSAO KUBERNETES
====================="

./install-kubernetes.sh




echo "==================
 SESSAO ANSIBLE
====================="

./install-ansible.sh



echo "==================
 SESSAO Deployments
====================="


./deploy-mysql-backend-front-loadBalance.sh

