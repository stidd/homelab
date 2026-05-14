#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
LONGHORN_VERSION="${LONGHORN_VERSION:-1.11.2}"
LONGHORN_HELM_TIMEOUT="${LONGHORN_HELM_TIMEOUT:-10m}"

helm repo add longhorn https://charts.longhorn.io 2>/dev/null || true
helm repo update

kubectl create namespace longhorn-system --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install longhorn longhorn/longhorn \
  --version "${LONGHORN_VERSION}" \
  --namespace longhorn-system \
  --create-namespace \
  --set defaultSettings.defaultDataPath=/var/lib/longhorn \
  --set persistence.defaultClassReplicaCount=3 \
  --timeout "${LONGHORN_HELM_TIMEOUT}" \
  --wait

kubectl -n longhorn-system rollout status deploy/longhorn-driver-deployer --timeout="${LONGHORN_HELM_TIMEOUT}"
kubectl -n longhorn-system rollout status deploy/longhorn-ui --timeout="${LONGHORN_HELM_TIMEOUT}"
kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/longhorn/longhorn-route.yaml"

echo "Longhorn ${LONGHORN_VERSION} installed behind Istio"
echo "Open: https://longhorn.steventidd.com"
