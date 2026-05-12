# Rancher

Installs Rancher and exposes the UI through Istio.

## Purpose

Rancher should be reachable at:

```text
rancher.steventidd.com
```

## Initial Shape

Expected resources:

- Rancher Helm release or manifests
- TLS certificate for `rancher.steventidd.com`
- Gateway API `HTTPRoute` to the Rancher service

## Notes

Since the cluster is not using Traefik, do not rely on a default Ingress
controller. Prefer explicit Gateway API routing through Istio.
