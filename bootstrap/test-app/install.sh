#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/test-apps/whoami"

kubectl -n whoami rollout status deploy/whoami
kubectl -n istio-ingress wait --for=condition=Programmed gateway/platform-gateway --timeout=180s

echo "whoami test app installed"
echo "Test with: curl http://whoami.steventidd.com"
