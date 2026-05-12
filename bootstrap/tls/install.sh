#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/cert-manager/certificates/steventidd-com-wildcard.yaml"
kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/istio/gateways/platform-gateway.yaml"

kubectl -n istio-ingress wait --for=condition=Ready certificate/steventidd-com-wildcard --timeout=120s
kubectl -n istio-ingress wait --for=condition=Programmed gateway/platform-gateway --timeout=180s

echo "Gateway TLS installed with self-signed wildcard certificate"
echo "Test with: curl -k https://whoami.steventidd.com"
