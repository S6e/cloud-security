#!/bin/bash

# Wechsele in das Verzeichnis des Scripts

export KUBECONFIG=/etc/kubernetes/admin.conf

source ${0%/*}/config.sh
source ~/.nodelist

cd "${0%/*}/.."

name=keycloak


# Delete keycloak

helm del --purge security-postgres-volumes
helm del --purge $name


# Delete created folders
pssh -H "${JOIN_NODES[*]}" -t 600 -o logs -i rm -rf $PV_POSTGRES_PATH

# Install keycloak

sh bin/setup-pv-for-keycloak-postgres.sh

helm install --name $name --namespace security \
 -f k8s/keycloak-helm/values.yaml stable/keycloak
