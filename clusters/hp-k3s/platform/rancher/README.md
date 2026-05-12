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
- Rancher installed with `ingress.enabled=false`
- Rancher installed with `tls=external`
- Gateway API `HTTPRoute` to the Rancher service on the HTTPS listener
- Gateway API `HTTPRoute` redirect from HTTP to HTTPS

## Notes

Since the cluster is not using Traefik, do not rely on a default Ingress
controller. Prefer explicit Gateway API routing through Istio.

TLS terminates at the shared Istio Gateway using the wildcard
`*.steventidd.com` certificate in `istio-ingress`.

## Bootstrap

Install with:

```bash
cd bootstrap
./rancher/install.sh
```

The default bootstrap password is `admin`. Override it with:

```bash
RANCHER_BOOTSTRAP_PASSWORD='<password>' ./rancher/install.sh
```

Validate:

```bash
kubectl -n cattle-system rollout status deploy/rancher
kubectl get httproute -n cattle-system
curl -I http://rancher.steventidd.com
curl -k https://rancher.steventidd.com
```
