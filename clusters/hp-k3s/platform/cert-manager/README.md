# cert-manager

Installs cert-manager and defines certificate issuers for platform services.

## Purpose

cert-manager should issue TLS certificates for hostnames exposed through the
Istio ingress gateway, including Rancher, Longhorn, and future apps.

## Initial Shape

Expected resources:

- cert-manager Helm release or manifests
- `ClusterIssuer` for an internal/self-signed issuer
- Wildcard `Certificate` for `*.steventidd.com`
- Later: `ClusterIssuer` for Let's Encrypt DNS-01

## Notes

Start with a simple internal issuer if public DNS automation is not ready. Move
to Let's Encrypt DNS-01 when the DNS provider and credentials are settled.

The current wildcard certificate is directly self-signed. This is enough to
validate Gateway TLS, but browsers will not trust it without manual trust
configuration.

## Bootstrap

The current bootstrap script installs cert-manager from the OCI Helm chart and
applies:

```text
issuers/selfsigned-clusterissuer.yaml
certificates/steventidd-com-wildcard.yaml
```

The wildcard certificate creates this secret for the Istio Gateway:

```text
istio-ingress/steventidd-com-tls
```
