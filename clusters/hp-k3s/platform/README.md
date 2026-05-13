# hp-k3s Platform

This directory is the GitOps entrypoint for platform services on the `hp-k3s`
cluster. Fleet should reconcile this path after the base k3s cluster and
kube-vip are working.

## Cluster Baseline

- Nodes: `hp1`, `hp2`, `hp3`
- Node IPs: `192.168.4.46`, `192.168.4.47`, `192.168.4.48`
- Kubernetes API VIP: `192.168.4.50`
- Shared ingress VIP: `192.168.4.60`
- Homelab DNS VIP: `192.168.4.61`
- LoadBalancer provider: kube-vip
- Ingress strategy: Istio ingress gateway using the shared ingress VIP

## Deployment Order

1. `dns`
2. `cert-manager`
3. `gateway-api`
4. `istio`
5. `test-apps`
6. `rancher`
7. `longhorn`
8. `observability`
9. `security-policies`

The early goal is to make DNS and ingress reliable before adding important UIs.
Mesh security should be enabled after the platform apps are reachable and
observable.

## Current Bootstrap Slice

The platform-core bootstrap slice is:

```bash
cd bootstrap
./platform-core/run.sh
```

It installs cert-manager, Gateway API CRDs, Istio ambient core, the shared
`platform-gateway`, and the `whoami` validation route.

The LAN DNS bootstrap is:

```bash
cd bootstrap
./dns/install.sh
```

It installs homelab CoreDNS at `192.168.4.61`.

The TLS bootstrap is:

```bash
cd bootstrap
./tls/install.sh
```

It creates a self-signed wildcard certificate for `*.steventidd.com` and adds
HTTPS to the shared Gateway.

Validation:

```bash
dig @192.168.4.61 whoami.steventidd.com
curl http://whoami.steventidd.com
curl -k https://whoami.steventidd.com
```

## Exposure Model

Only the Istio ingress gateway should normally use a `LoadBalancer` service.
Application services should stay internal as `ClusterIP` services and be exposed
through Gateway API resources.

Example app DNS targets:

```text
rancher.steventidd.com  -> 192.168.4.60
longhorn.steventidd.com -> 192.168.4.60
grafana.steventidd.com  -> 192.168.4.60
```

Istio routes requests by hostname to the correct in-cluster service.

Homelab clients should use the LAN DNS service:

```text
192.168.4.61
```

That DNS service resolves `*.steventidd.com` to the shared Istio ingress VIP.
On macOS clients, prefer split DNS with `/etc/resolver/steventidd.com` so only
homelab names use `192.168.4.61`.

## Directory Roles

- `dns`: LAN DNS for homelab hostnames.
- `cert-manager`: cert-manager installation and cluster issuers.
- `gateway-api`: Gateway API CRDs required by Istio Gateway resources.
- `istio`: Istio base, control plane, ambient dataplane, and ingress gateway.
- `test-apps`: Disposable validation apps used before exposing real services.
- `rancher`: Rancher installation and Gateway API routing.
- `longhorn`: Longhorn installation and Gateway API routing for the UI.
- `observability`: Metrics, dashboards, tracing, and mesh visibility.
- `security-policies`: Istio authorization, peer auth, and namespace enrollment.

## Fleet Bundles

Fleet uses one `GitRepo` named `homelab` with multiple explicit paths. The
registration lives in:

```text
bootstrap/fleet/gitrepo.yaml
```

Current Fleet-managed paths:

- `clusters/hp-k3s/platform/dns`
- `clusters/hp-k3s/platform/cert-manager`
- `clusters/hp-k3s/platform/istio`
- `clusters/hp-k3s/platform/test-apps`
- `clusters/hp-k3s/platform/rancher`

Planned paths:

- `clusters/hp-k3s/platform/longhorn`
- `clusters/hp-k3s/platform/observability`
- `clusters/hp-k3s/platform/security-policies`
- `clusters/hp-k3s/apps`

The foundational Helm installs remain bootstrap-managed for now. Fleet manages
the Kubernetes configuration that sits on top of those installs.

## Operating Principles

- Prefer Gateway API resources over legacy Kubernetes Ingress.
- Keep one shared external ingress IP until a concrete need appears for more.
- Do not enable mesh enforcement cluster-wide as a first step.
- Enroll namespaces into ambient mode deliberately and one at a time.
- Add waypoint proxies only where L7 policy or richer telemetry is needed.
