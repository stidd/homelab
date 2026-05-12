#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ISTIO_VERSION="${ISTIO_VERSION:-1.29.2}"
ISTIO_HELM_TIMEOUT="${ISTIO_HELM_TIMEOUT:-10m}"

helm repo add istio https://istio-release.storage.googleapis.com/charts 2>/dev/null || true
helm repo update

kubectl create namespace istio-system --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace istio-ingress --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install istio-base istio/base \
  --version "${ISTIO_VERSION}" \
  --namespace istio-system \
  --timeout "${ISTIO_HELM_TIMEOUT}" \
  --wait

helm upgrade --install istiod istio/istiod \
  --version "${ISTIO_VERSION}" \
  --namespace istio-system \
  --set profile=ambient \
  --timeout "${ISTIO_HELM_TIMEOUT}" \
  --wait

kubectl -n istio-system rollout status deploy/istiod --timeout="${ISTIO_HELM_TIMEOUT}"

helm upgrade --install istio-cni istio/cni \
  --version "${ISTIO_VERSION}" \
  --namespace istio-system \
  --set profile=ambient \
  --set global.platform=k3s \
  --timeout "${ISTIO_HELM_TIMEOUT}" \
  --wait

helm upgrade --install ztunnel istio/ztunnel \
  --version "${ISTIO_VERSION}" \
  --namespace istio-system \
  --timeout "${ISTIO_HELM_TIMEOUT}"

kubectl -n istio-system rollout status ds/istio-cni-node --timeout="${ISTIO_HELM_TIMEOUT}"
kubectl -n istio-system rollout restart ds/ztunnel
kubectl -n istio-system rollout status ds/ztunnel --timeout="${ISTIO_HELM_TIMEOUT}"

kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/istio/gateways/platform-gateway.yaml"
kubectl -n istio-ingress wait --for=condition=Programmed gateway/platform-gateway --timeout=180s

echo "Istio ${ISTIO_VERSION} ambient core and platform gateway installed"
