# Fleet Registration

Registers GitOps bundles for the homelab cluster.

## Boundary

Fleet manages Kubernetes resources that are safe to reconcile repeatedly:

- Homelab DNS CoreDNS resources
- cert-manager issuers and certificates
- Istio Gateway configuration
- test app routes and manifests
- Rancher Gateway API routes
- future Longhorn route resources
- future application manifests

Bootstrap still manages foundational installs:

- cert-manager Helm chart
- Gateway API CRDs
- Istio Helm charts
- Rancher Helm chart
- initial Fleet GitRepo registration

## Register

Make sure the current branch is committed and pushed, then apply:

```bash
kubectl apply -f bootstrap/fleet/gitrepo.yaml
```

Watch:

```bash
kubectl get gitrepo -n fleet-local
kubectl get bundles -A
kubectl get bundledeployments -A
```

## GitRepo

The bootstrap applies one `GitRepo` named `homelab`. It uses multiple explicit
paths so Fleet creates separate bundles for the active platform layers.

Current paths:

- `clusters/hp-k3s/platform/dns`
- `clusters/hp-k3s/platform/cert-manager`
- `clusters/hp-k3s/platform/istio`
- `clusters/hp-k3s/platform/test-apps`
- `clusters/hp-k3s/platform/rancher`

Add future paths when they contain real manifests:

- `clusters/hp-k3s/platform/longhorn`
- `clusters/hp-k3s/platform/observability`
- `clusters/hp-k3s/platform/security-policies`
- `clusters/hp-k3s/apps`

## Bootstrap Adoption

The platform resources were first created by bootstrap scripts. Fleet deploys
manifest bundles through Helm, so each active layer sets:

```yaml
helm:
  takeOwnership: true
```

This allows Fleet to adopt the existing resources instead of failing on missing
Helm ownership labels and annotations.
