#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting homelab bootstrap..."

echo "📦 Installing cert-manager..."
./cert-manager/install.sh

echo "🧭 Installing Rancher..."
./rancher/install.sh

echo "⏳ Waiting for Rancher to become ready..."
kubectl -n cattle-system rollout status deploy/rancher

echo "🔗 Applying Fleet GitRepo..."
kubectl apply -f fleet/gitrepo.yaml

echo "✅ Bootstrap complete!"
echo "👉 Open: https://rancher.steventidd.com"