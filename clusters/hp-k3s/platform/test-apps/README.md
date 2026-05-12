# Test Apps

Disposable apps used to prove the platform path before exposing important UIs.

## Purpose

Use this directory to validate:

- DNS resolves homelab names through `192.168.4.61`
- kube-vip assigns the Istio ingress gateway IP
- Gateway API routing works
- Istio routes requests to the intended service

## First App

A simple echo/whoami app is enough for the first validation route.

Example hostname:

```text
whoami.steventidd.com
```

Validate the route before installing Rancher:

```bash
curl http://whoami.steventidd.com
curl -k https://whoami.steventidd.com
```

The HTTPS test uses `-k` because the current wildcard certificate is
self-signed.
