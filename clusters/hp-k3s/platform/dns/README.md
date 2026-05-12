# DNS

Runs a small LAN DNS service for homelab hostnames.

## Purpose

The DNS service should answer local app hostnames and forward all other queries
to upstream resolvers.

Reserved address:

```text
192.168.4.61
```

Primary local rule:

```text
*.steventidd.com -> 192.168.4.60
```

Clients on the LAN can use `192.168.4.61` as their DNS server. For now, prefer
client-side split DNS instead of changing router/DHCP settings.

On macOS:

```bash
sudo mkdir -p /etc/resolver
sudo tee /etc/resolver/steventidd.com >/dev/null <<'EOF'
nameserver 192.168.4.61
EOF
```

Validate:

```bash
dscacheutil -q host -a name whoami.steventidd.com
curl http://whoami.steventidd.com
```

## Initial Shape

Expected resources:

- `homelab-dns` namespace
- CoreDNS ConfigMap
- CoreDNS Deployment
- `LoadBalancer` Service requesting `192.168.4.61`

## Bootstrap

Deploy with:

```bash
cd bootstrap
./dns/install.sh
```

Validate direct DNS:

```bash
dig @192.168.4.61 whoami.steventidd.com
dig @192.168.4.61 google.com
```

## Notes

This is separate from Kubernetes' internal CoreDNS instance in `kube-system`.
Do not modify the cluster DNS deployment for LAN records.
