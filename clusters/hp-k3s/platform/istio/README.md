# Istio

Installs Istio as the cluster ingress gateway and future service mesh.

## Purpose

Istio should provide:

- One shared ingress gateway on `192.168.4.60`
- Hostname-based routing for platform UIs and apps
- Ambient mesh security for service-to-service traffic later

## Initial Shape

Expected resources:

- Istio base
- Istio control plane
- Istio CNI configured for ambient mode and k3s
- ztunnel
- Shared platform `Gateway`

## Install Notes

For k3s, Istio should be installed with the platform value set to k3s:

```text
global.platform=k3s
```

The ingress gateway service should be the normal owner of the single kube-vip
service address:

```text
192.168.4.60
```

The `platform-gateway` resource uses Istio's Gateway API automated deployment.
Its generated service is customized with `loadBalancerIP: 192.168.4.60`.

## Adoption Notes

Do not start with strict mesh enforcement. First validate ingress with a test
application, then expose Rancher and Longhorn, then enroll namespaces into
ambient mode one at a time.
