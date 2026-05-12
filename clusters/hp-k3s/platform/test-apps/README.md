# Test Apps

Disposable apps used to prove the platform path before exposing important UIs.

## Purpose

Use this directory to validate:

- DNS points at `192.168.4.60`
- kube-vip assigns the Istio ingress gateway IP
- Gateway API routing works
- TLS issuance works
- Istio routes requests to the intended service

## First App

A simple echo/whoami app is enough for the first validation route.

Example hostname:

```text
whoami.steventidd.com
```

Validate the route before installing Rancher:

```bash
curl -H 'Host: whoami.steventidd.com' http://192.168.4.60/
```
