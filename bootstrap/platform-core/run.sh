#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${BOOTSTRAP_DIR}"

echo "Starting platform-core bootstrap..."

echo "Installing cert-manager..."
./cert-manager/install.sh

echo "Installing Gateway API CRDs..."
./gateway-api/install.sh

echo "Installing Istio ambient core and platform gateway..."
./istio/install.sh

echo "Installing whoami test route..."
./test-app/install.sh

echo "platform-core bootstrap complete"
echo "Try: curl http://whoami.steventidd.com"
