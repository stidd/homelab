#!/usr/bin/env bash
set -euo pipefail

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest 2>/dev/null || true
helm repo update

kubectl create namespace cattle-system --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.steventidd.com \
  --set replicas=1 \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=rancher

echo "✔ Rancher installation triggered"