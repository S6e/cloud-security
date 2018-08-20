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
# Install gravitee api gateway
##################################################

# Download gravitee if it's not here yet
if [ -d k8s/gravitee-helm ]
	then git pull
	else git clone https://github.com/S6e/gravitee-kubernetes.git k8s/gravitee-helm
fi

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

# Install postgres
sh bin/setup-pv-for-keycloak-postgres.sh

helm install --name keycloak --namespace $ns \
 -f k8s/keycloak-helm/values.yaml stable/keycloak


####################################################
# Install showcase
####################################################

sed -i "s/traefik/nginx/g" k8s/cloud-native-javaee/kubernetes/dashboard-service-ingress.yaml
kubectl apply -f k8s/cloud-native-javaee/kubernetes/ -n $ns


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

modify_hosts_file gravitee-api gravitee-gateway gravitee-ui keycloak dashboard-service
