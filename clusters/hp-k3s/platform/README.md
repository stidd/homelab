# hp-k3s Platform

This directory is the GitOps entrypoint for platform services on the `hp-k3s`
cluster. Fleet should reconcile this path after the base k3s cluster and
kube-vip are working.

## Cluster Baseline

- Nodes: `hp1`, `hp2`, `hp3`
- Node IPs: `192.168.4.46`, `192.168.4.47`, `192.168.4.48`
- Kubernetes API VIP: `192.168.4.50`
- Shared ingress VIP: `192.168.4.60`
- LoadBalancer provider: kube-vip
- Ingress strategy: Istio ingress gateway using the shared ingress VIP

## Deployment Order

1. `cert-manager`
2. `gateway-api`
3. `istio`
4. `test-apps`
5. `rancher`
6. `longhorn`
7. `observability`
8. `security-policies`

The early goal is to make ingress reliable before adding important UIs. Mesh
security should be enabled after the platform apps are reachable and observable.

## Current Bootstrap Slice

The first runnable bootstrap slice is:

```bash
cd bootstrap
./platform-core/run.sh
```

It installs cert-manager, Gateway API CRDs, Istio ambient core, the shared
`platform-gateway`, and the `whoami` validation route.

Validation:

```bash
curl -H 'Host: whoami.steventidd.com' http://192.168.4.60/
```

## Exposure Model

Only the Istio ingress gateway should normally use a `LoadBalancer` service.
Application services should stay internal as `ClusterIP` services and be exposed
through Gateway API resources.

Example DNS targets:

```text
rancher.steventidd.com  -> 192.168.4.60
longhorn.steventidd.com -> 192.168.4.60
grafana.steventidd.com  -> 192.168.4.60
```

Istio routes requests by hostname to the correct in-cluster service.

## Directory Roles

- `cert-manager`: cert-manager installation and cluster issuers.
- `gateway-api`: Gateway API CRDs required by Istio Gateway resources.
- `istio`: Istio base, control plane, ambient dataplane, and ingress gateway.
- `test-apps`: Disposable validation apps used before exposing real services.
- `rancher`: Rancher installation and Gateway API routing.
- `longhorn`: Longhorn installation and Gateway API routing for the UI.
- `observability`: Metrics, dashboards, tracing, and mesh visibility.
- `security-policies`: Istio authorization, peer auth, and namespace enrollment.

## Operating Principles

- Prefer Gateway API resources over legacy Kubernetes Ingress.
- Keep one shared external ingress IP until a concrete need appears for more.
- Do not enable mesh enforcement cluster-wide as a first step.
- Enroll namespaces into ambient mode deliberately and one at a time.
- Add waypoint proxies only where L7 policy or richer telemetry is needed.
