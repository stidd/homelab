# Longhorn

Installs Longhorn and exposes the UI through Istio.

## Purpose

Longhorn provides distributed storage for the k3s cluster. The UI should be
reachable at:

```text
longhorn.steventidd.com
```

## Initial Shape

Expected resources:

- Longhorn Helm release or manifests
- TLS certificate for `longhorn.steventidd.com`
- Gateway API `HTTPRoute` to the Longhorn frontend service

The Longhorn path should be added to the `homelab` Fleet GitRepo once Longhorn
route manifests are added.

## Prerequisites

Each node should have the Longhorn disk mounted at:

```text
/var/lib/longhorn
```

See `homelab-k3s/create-mount-for-longhorn.md` and
`ansible/rocky/prepare-longhorn-disk.yaml`.
