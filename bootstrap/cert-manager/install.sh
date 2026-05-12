#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CERT_MANAGER_VERSION="${CERT_MANAGER_VERSION:-v1.20.2}"

kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version "${CERT_MANAGER_VERSION}" \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

kubectl -n cert-manager rollout status deploy/cert-manager
kubectl -n cert-manager rollout status deploy/cert-manager-webhook
kubectl -n cert-manager rollout status deploy/cert-manager-cainjector

kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/cert-manager/issuers/selfsigned-clusterissuer.yaml"

echo "cert-manager ${CERT_MANAGER_VERSION} installed"
