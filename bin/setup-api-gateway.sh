#!/bin/bash

##################################################
#
# The script installs the Gravitee image in the Kubernetes cluster.
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

cd "${0%/*}/.."

# namespace for showcase
ns=security

##################################################
# Install mongodb with replicaset
##################################################

# create directories
#pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i mkdir -p $PV_PATH/{0,1,2,3,4,5,6,7,8,9}
# Install persistent volumes
#helm install k8s/mongodb-volumes/mongodb-volumes-0.1.0.tgz --name mongodb-volumes --set nodes="{$JOIN_NODES_COMMA_SEP}" --set size=$PV_SIZE --set volumes=$PV_VOLUMES_PER_NODE --set storageClassName=api-gw-mongodb-data --set path=$PV_PATH


##################################################
# Install elasticsearch Persistent Volume
##################################################

# create directories
#pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i mkdir -p $PV_PATH/{0,1,2,3,4,5,6,7,8,9}
# Install persistent volumes
#helm install k8s/elasticsearch-volumes/elasticsearch-volumes-0.1.0.tgz --name api-gw-elasticsearch-volumes --set nodes="{$JOIN_NODES_COMMA_SEP}" --set size=$PV_SIZE --set volumes=$PV_VOLUMES_PER_NODE --set storageClassName=api-gw-es-data --set path=$PV_PATH


##################################################
# Install gravitee api gateway
##################################################

# Download gravitee if it's not here yet
if [ -d k8s/gravitee-helm ]
	then git pull
	else git clone https://github.com/S6e/gravitee-kubernetes.git k8s/gravitee-helm
fi

# disable elasticsearch
#sed -n '51s/true/false/' k8s/gravitee-helm/gravitee/templates/gateway-configmap.yaml

kubectl create ns $ns

# Install mongodb
sh bin/setup-pv-for-mongodb.sh

# Install elasticsearch
sh bin/setup-elasticsearch.sh

# Install gravitee
helm install --name api-gateway --namespace $ns \
 -f k8s/gravitee-helm/gravitee/values.yaml k8s/gravitee-helm/gravitee


####################################################
# Install Keycloak
####################################################

#helm install --name keycloak --namespace $ns \
# -f k8s/keycloak-helm/values.yaml stable/keycloak


####################################################
# Modify /etc/hosts of master node
####################################################

modify_hosts_file() {
	# loop for all parameters
	for host in "$@"
	do
		grep -q -F "127.0.0.1 $host.local" /etc/hosts || \
		echo "127.0.0.1 $host.local" >> /etc/hosts
	done
}

modify_hosts_file gravitee #keycloak
