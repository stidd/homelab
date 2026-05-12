# cert-manager

Installs cert-manager and defines certificate issuers for platform services.

## Purpose

cert-manager should issue TLS certificates for hostnames exposed through the
Istio ingress gateway, including Rancher, Longhorn, and future apps.

## Initial Shape

Expected resources:

- cert-manager Helm release or manifests
- `ClusterIssuer` for an internal/self-signed issuer
- Later: `ClusterIssuer` for Let's Encrypt DNS-01

## Notes

Start with a simple internal issuer if public DNS automation is not ready. Move
to Let's Encrypt DNS-01 when the DNS provider and credentials are settled.

## Bootstrap

The current bootstrap script installs cert-manager from the OCI Helm chart and
applies:

```text
issuers/selfsigned-clusterissuer.yaml
```
