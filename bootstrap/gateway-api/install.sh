#!/usr/bin/env bash
set -euo pipefail

GATEWAY_API_VERSION="${GATEWAY_API_VERSION:-v1.4.0}"

kubectl apply --server-side -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/${GATEWAY_API_VERSION}/standard-install.yaml"

kubectl wait --for=condition=Established crd/gatewayclasses.gateway.networking.k8s.io --timeout=120s
kubectl wait --for=condition=Established crd/gateways.gateway.networking.k8s.io --timeout=120s
kubectl wait --for=condition=Established crd/httproutes.gateway.networking.k8s.io --timeout=120s

echo "Gateway API ${GATEWAY_API_VERSION} installed"
