#!/bin/bash

##################################################
#
# Clean the Cloud Native Java EE showcase
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

cd ${0%/*}/
#kubectl delete ns cloud-native-javaee
kubectl delete -f ../k8s/cloud-native-javaee/kubernetes/ -n security
sed -i '/127.0.0.1 dashboard-service.local/d' /etc/hosts

# install showcase
cd ${0%/*}/
sed -i "s/traefik/nginx/g" ../k8s/cloud-native-javaee/kubernetes/dashboard-service-ingress.yaml
kubectl apply -f ../k8s/cloud-native-javaee/kubernetes/ -n security
grep -q -F '127.0.0.1 dashboard-service.local' /etc/hosts || echo '127.0.0.1 dashboard-service.local' >> /etc/hosts
