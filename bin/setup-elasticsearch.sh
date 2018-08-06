#!/bin/bash

##################################################
#
# The script installs the Elasticsearch cluster.
#
# It creates necessary persistent volumes and a custom resource for the
# Elasticsearch cluster which is processed by a Kubernetes operator
# (https://github.com/upmc-enterprises/elasticsearch-operator)
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

source ${0%/*}/config.sh
source ~/.nodelist

cd "${0%/*}/.."

# create directories
pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i mkdir -p $PV_ES_PATH/{0,1,2,3,4,5,6,7,8,9}

# Install persistent volumes
helm install k8s/persistent-volumes --name security-es-volumes \
--set nodes="{$JOIN_NODES_COMMA_SEP}" --set size=$PV_ES_SIZE \
--set volumes=$PV_ES_VOLUMES_PER_NODE --set storageClassName=security-es-data \
--set path=$PV_ES_PATH --set kibana.enabled=false --set kibana.enabled=false \
--set cerebro.enabled=false

# Install elasticsearch cluster
kubectl create -f k8s/elasticsearch.yaml -n security
