# Observability

Metrics, dashboards, tracing, and mesh visibility.

## Purpose

Observability should be in place before enforcing broad mesh security policies.
It should help answer which services are talking, whether mTLS is active, and
which policy blocked a request.

## Initial Shape

Expected resources may include:

- Prometheus or another metrics backend
- Grafana
- Kiali
- Istio telemetry configuration
- Optional tracing backend
