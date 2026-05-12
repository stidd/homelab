#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
RANCHER_BOOTSTRAP_PASSWORD="${RANCHER_BOOTSTRAP_PASSWORD:-admin}"
RANCHER_HELM_TIMEOUT="${RANCHER_HELM_TIMEOUT:-10m}"

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest 2>/dev/null || true
helm repo update

kubectl create namespace cattle-system --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --create-namespace \
  --set hostname=rancher.steventidd.com \
  --set ingress.enabled=false \
  --set tls=external \
  --set replicas=1 \
  --set bootstrapPassword="${RANCHER_BOOTSTRAP_PASSWORD}" \
  --timeout "${RANCHER_HELM_TIMEOUT}" \
  --wait

kubectl -n cattle-system rollout status deploy/rancher --timeout="${RANCHER_HELM_TIMEOUT}"
kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/rancher/rancher-route.yaml"

echo "Rancher installed behind Istio"
echo "Open: https://rancher.steventidd.com"
