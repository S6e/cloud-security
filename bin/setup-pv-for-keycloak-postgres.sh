#!/bin/bash

##################################################
#
# The script installs persistent volume (pv) for Postgres 
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

source ${0%/*}/config.sh
source ~/.nodelist

cd "${0%/*}/.."

# create directories
pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i mkdir -p $PV_POSTGRES_PATH/{0,1,2,3,4,5,6,7,8,9}

# Install persistent volumes
helm install k8s/persistent-volumes --name security-postgres-volumes \
--set nodes="{$JOIN_NODES_COMMA_SEP}" --set size=$PV_POSTGRES_SIZE \
--set volumes=$PV_POSTGRES_VOLUMES_PER_NODE --set storageClassName=security-postgres-data \
--set path=$PV_POSTGRES_PATH
