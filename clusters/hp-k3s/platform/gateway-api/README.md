# Gateway API

Installs the Kubernetes Gateway API CRDs used by Istio.

## Purpose

Gateway API provides the `Gateway`, `HTTPRoute`, and related resources that
describe north-south traffic into the cluster.

## Initial Shape

Expected resources:

- Gateway API standard CRDs

## Notes

Install these CRDs before applying Istio `Gateway` or `HTTPRoute` resources.

The bootstrap script applies the Gateway API `standard-install.yaml` release for
the pinned version.
