# Homelab Bootstrap

This directory bootstraps the cluster to a state where GitOps (Fleet) can take
over.

## Platform Core

Use this to establish the shared ingress path before installing Rancher:

```bash
./platform-core/run.sh
```

What it installs:

1. cert-manager
2. Gateway API CRDs
3. Istio ambient core
4. Istio `platform-gateway` on `192.168.4.60`
5. `whoami.steventidd.com` test route

Optional LAN DNS bootstrap:

```bash
./dns/install.sh
```

This deploys a separate CoreDNS service at `192.168.4.61` for homelab client
DNS and resolves `*.steventidd.com` to `192.168.4.60`.

Validation:

```bash
dig @192.168.4.61 whoami.steventidd.com
curl http://whoami.steventidd.com
```

## Full Bootstrap Draft

The older full bootstrap flow is still a working draft for Rancher and Fleet.
It should be revised before use so Rancher is exposed through Istio instead of
assuming a default Ingress controller.

## What this does
1. Installs cert-manager
2. Installs Rancher
3. Registers GitHub repo with Fleet

## Requirements
- K3s cluster already deployed
- kubeconfig configured
- Helm installed

## Run

Platform core:

```bash
cd bootstrap
./platform-core/run.sh
```

Full bootstrap draft:

```bash
cd bootstrap
./run.sh
```

After completion:

- Access Rancher at https://rancher.steventidd.com
- Login with bootstrap password
- Fleet will begin reconciling the repo
