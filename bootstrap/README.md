# Homelab Bootstrap

This directory bootstraps the cluster to a state where GitOps (Fleet) takes over.

## What this does
1. Installs cert-manager
2. Installs Rancher
3. Registers GitHub repo with Fleet

## Requirements
- K3s cluster already deployed
- kubeconfig configured
- Helm installed

## Run
cd bootstrap
./run.sh

After completion:

- Access Rancher at https://rancher.steventidd.com
- Login with bootstrap password
- Fleet will begin reconciling the repo