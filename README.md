# homelab

## Cluster Baseline

This repository manages a three-node k3s homelab cluster and the platform
services that sit on top of it.

## Nodes

```text
hp1 = 192.168.4.46
hp2 = 192.168.4.47
hp3 = 192.168.4.48
```

## VIPs

```text
192.168.4.50 = Kubernetes API
192.168.4.60 = Istio ingress gateway
192.168.4.61 = Homelab LAN DNS
```

## Platform

The platform bootstrap currently installs:

- cert-manager
- Gateway API CRDs
- Istio ambient core
- Istio Gateway API ingress on `192.168.4.60`
- CoreDNS LAN DNS on `192.168.4.61`
- `whoami.steventidd.com` test route

Platform manifests live under:

```text
clusters/hp-k3s/platform
```

Fleet registration manifests live under:

```text
bootstrap/fleet
```

Fleet manages platform configuration, routes, DNS, certificates, and future app
manifests. Bootstrap remains responsible for foundational installs such as k3s,
kube-vip, cert-manager, Istio, and Rancher.
