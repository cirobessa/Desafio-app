#!/bin/bash


### VARIAVEIS Do script

## IP do cluster
IP_CLUSTER=172.16.48.163

## RANGE IP dos PODs
IP_RANGE=10.20.30.0/24

## primeiro IP FLANNEL
IP_FLANNEL=10.20.30.1/24


# Retira SWAP

sudo swapoff -a
sudo cat /etc/fstab | sed s/swap/swuuup/g > /tmp/tt ; sudo cp /tmp/tt /etc/fstab


# BAixa chave dos repositorios
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF


# instala dependencias
sudo apt-get update 
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Desativa Swap, exigencia Kubernetes
 sudo swapoff -a
sudo sysctl vm.swappiness=0
sudo echo 3 > /proc/sys/vm/drop_caches
sudo echo vm.swappiness=0 | sudo tee -a /etc/sysctl.conf
sudo apt-get update 


sudo kubeadm config images pull

echo "==================
 SESSAO SOBE CLUSTER KUBEADM
====================="
 
 sudo kubeadm init --pod-network-cidr=$IP_RANGE --apiserver-advertise-address=$IP_CLUSTER




 mkdir -p $HOME/.kube
  
 sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo cp -f /etc/kubernetes/admin.conf $HOME/ 
sudo chown $(id -u):$(id -g) $HOME/.kube/config




sudo useradd kubo -G sudo -m -s /bin/bash
#sudo passwd  kubo 
#sudo su kubo

sudo cp -f /etc/kubernetes/admin.conf /home/kudo
 sudo chown kudo:kudo /home/kudo

export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >> /home/kudo/.bashrc

echo "export KUBECONFIG=$HOME/admin.conf" >> ~/.bashrc


### CHECKUP
sudo kubectl  get pods -n kube-system
sudo kubectl config current-context
 sleep 1
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

sudo kubectl cluster-info



echo CHAMADA DOS WORKERs NODEs, se houver disponivel

sudo kubeadm token create --print-join-command



echo ACerta rede
sudo mkdir -p /var/lib/weave
head -c 16 /dev/urandom | shasum -a 256 | cut -d" " -f1 | sudo tee /var/lib/weave/weave-passwd

kubectl create secret -n kube-system generic weave-passwd --from-file=/var/lib/weave/weave-passwd

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&password-secret=weave-passwd&env.IPALLOC_RANGE=$IP_RANGE "

# Declara as Flannel do cni
echo "FLANNEL_NETWORK=$IP_RANGE 
FLANNEL_SUBNET=$IP_FLANNEL
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true"  >  /run/flannel/subnet.env 

## Reset nas permissoes do usuario operador
sudo chown -R `id -u` .

echo LIbera portas do FIrewall
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 6443
sudo ufw allow 6783/udp
sudo ufw allow 6784/udp
sudo ufw allow 6783/tcp
sudo ufw allow 30001
sudo ufw allow 30002
sudo ufw allow 30003
sudo ufw allow 30004
sudo ufw allow 30005
sudo ufw allow 30006

sudo ufw enable


### REtira o TAINT para subir no pods no master node
sudo kubectl taint nodes $HOSTNAME node-role.kubernetes.io/master-




