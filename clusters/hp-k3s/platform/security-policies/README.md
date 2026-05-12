# Security Policies

Istio mesh security and service communication policy.

## Purpose

Use this directory after ingress and platform apps are stable. Policies should
be introduced namespace by namespace.

## Initial Shape

Expected resources:

- Namespace ambient enrollment labels
- `PeerAuthentication`
- `AuthorizationPolicy`
- Waypoint configuration where L7 policy is needed

## Rollout Order

1. Pick a low-risk namespace.
2. Enable ambient mode for that namespace.
3. Verify service-to-service traffic still works.
4. Add permissive policies.
5. Move toward explicit allow policies.
6. Repeat for the next namespace.
