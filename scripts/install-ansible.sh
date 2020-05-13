#!/bin/bash



### INSTALA O RedHat Ansible

sudo apt update
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y