#!/bin/bash

### FEITO POR CIRO BESSA
#

## retira o Taint do master node Kubernete
sudo kubectl taint nodes --all node-role.kubernetes.io/master-


# Trem nao pronto!
sl -la

