#!/bin/bash

##################################################
#
# Script that removes the whole security showcase.
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

rm -r k8s/gravitee-helm/
helm del --purge api-gateway
kubectl delete ns security

# Remove changes to /etc/hosts
sed -i '/127.0.0.1 gravitee.local/d' /etc/hosts
