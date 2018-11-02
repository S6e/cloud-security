#!/bin/bash

##################################################
#
# Script that reinstalls elasticsearch.
#
##################################################
 
export KUBECONFIG=/etc/kubernetes/admin.conf

source ${0%/*}/config.sh
source ~/.nodelist
 
# Delete kubernetes deployment of elasticsearch
kubectl delete -f k8s/elasticsearch.yaml -n security
 
# Delete persistent volumes of elasticsearch
helm del --purge security-es-volumes

# Delete created folders
pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i rm -rf $PV_ES_PATH

# Install elasticsearch
sh bin/setup-elasticsearch.sh
