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
- Gateway API `HTTPRoute` to the Longhorn frontend service
- Gateway API `HTTPRoute` redirect from HTTP to HTTPS

TLS terminates at the shared Istio Gateway using the wildcard
`*.steventidd.com` certificate in `istio-ingress`.

The Longhorn path is included in the `homelab` Fleet GitRepo once route
manifests are committed and pushed.

## Prerequisites

Each node should have the Longhorn disk mounted at:

```text
/var/lib/longhorn
```

See `homelab-k3s/create-mount-for-longhorn.md` and
`ansible/rocky/prepare-longhorn-disk.yaml`.

Longhorn also needs iSCSI support on each node. The Rocky prep playbook installs
`iscsi-initiator-utils` and starts `iscsid`.

## Bootstrap

Install with:

```bash
cd bootstrap
./longhorn/install.sh
```

Validate:

```bash
kubectl get pods -n longhorn-system
kubectl get httproute -n longhorn-system
curl -I http://longhorn.steventidd.com
curl -k https://longhorn.steventidd.com
```

The Longhorn UI does not provide its own authentication when installed this way.
Keep it LAN-only unless an auth layer is added.
