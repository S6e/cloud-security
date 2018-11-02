# Wechsele in das Verzeichnis des Scripts
cd "${0%/*}/.."

name=api-gateway

# Delete gravitee

helm del --purge $name

# Install gravitee

helm install --name $name --namespace security \
 -f k8s/gravitee-helm/gravitee/values.yaml k8s/gravitee-helm/gravitee
