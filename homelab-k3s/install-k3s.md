# Installing 3 node HA K3s cluster

1. utilize the prep-k3s.yaml ansible file at rocky/prep-k3s.yaml to prep nodes for k3s install

```bash

ansible-playbook -i inventory.ini prep-k3s.yml
```

2. install k3s on first node:

```bash
curl -sfL https://get.k3s.io | sudo sh -s - server \ --cluster-init \ --node-ip 192.168.4.46 \ --tls-san 192.168.4.46 \ --write-kubeconfig-mode 644
```

3. grab the join token then you're ready to join other nodes:

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

4. on subsequent nodes:

```bash
curl -sfL https://get.k3s.io | sudo K3S_TOKEN='<TOKEN>' sh -s - server \
  --server https://192.168.4.46:6443 \
  --node-ip 192.168.4.47 \
  --tls-san 192.168.4.47 \
  --write-kubeconfig-mode 644
```