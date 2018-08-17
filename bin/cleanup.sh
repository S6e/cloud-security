#!/bin/bash

##################################################
#
# Script that removes the whole security showcase.
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

source ${0%/*}/config.sh
source ~/.nodelist


##################################################
# Remove Helm Charts, persistent volumes and namespace
##################################################

# Delete helm charts
kubectl delete -f k8s/elasticsearch.yaml -n security
helm del --purge api-gateway
helm del --purge keycloak

# Delete persistent volumes of mongodb and elasticsearch
helm del --purge security-mongodb-volumes
helm del --purge security-es-volumes
helm del --purge security-postgres-volumes

# Delete created folders
pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i rm -rf $PV_MONGODB_PATH
pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i rm -rf $PV_ES_PATH
pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i rm -rf $PV_POSTGRES_PATH


# Remove namespace security
kubectl delete ns security


##################################################
# Clean /etc/hosts
##################################################

clean_hosts_file() {
	for host in "$@"
	do
		sed -i "/127.0.0.1 $host.local/d" /etc/hosts
	done
}

clean_hosts_file gravitee gravitee-api gravitee-gateway gravitee-ui keycloak
