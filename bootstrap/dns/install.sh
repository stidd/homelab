#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

kubectl apply -f "${REPO_ROOT}/homelab-k3s/manifests/kube-vip/kubevip-configmap.yaml"
kubectl apply -f "${REPO_ROOT}/clusters/hp-k3s/platform/dns/coredns/coredns.yaml"

kubectl -n homelab-dns rollout status deploy/homelab-coredns

echo "Homelab DNS installed at 192.168.4.61"
echo "Test with: dig @192.168.4.61 whoami.steventidd.com"
