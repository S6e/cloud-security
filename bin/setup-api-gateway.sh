#!/bin/bash

##################################################
#
# The script installs the Gravitee image in the Kubernetes cluster.
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

cd "${0%/*}/.."

git clone https://github.com/S6e/gravitee-kubernetes.git k8s/gravitee-helm

# disable elasticsearch due to error (httpclient)
#sed '51s/true/false/' gravitee/templates/gateway-configmap.yaml

helm install --name api-gateway --namespace security \
 -f k8s/gravitee-helm/gravitee/values.yaml k8s/gravitee-helm/gravitee

# Modify /etc/hosts of master node
grep -q -F '127.0.0.1 gravitee.local' /etc/hosts || \
echo '127.0.0.1 gravitee.local' >> /etc/hosts
