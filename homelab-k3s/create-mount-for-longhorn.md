# Deleting Windows partition and creating a new partition and mount for Longhorn distributed storage

# Do this on each node of the cluster

1. open fdisk

```bash
sudo fdisk /dev/nvme0n1
```

2. Inspect partitions

```bash
p
```
Confirm you see:

```bash
p3 → Windows
p4 → recovery
p5 → /boot
p6 → LVM
```

3. Delete Windows partitions

```bash
d
3
d
4
```
4. Create new partition

```bash
n
7
<Enter> # first sector
<Enter> # last sector
Y       # remove signature
```

5. Sanity check

```bash
p
```

You should see:

```bash
p1
p2
p5
p6
p7 (~137.8G)
```

6. Write changes

```bash
w
```

7. Refresh partition table

```bash
sudo partprobe /dev/nvme0n1
lsblk
```

8. Format disk

```bash
sudo mkfs.xfs -f /dev/nvme0n1p7
```

9. Create mount point

```bash
sudo mkdir -p /var/lib/longhorn
```

10. Get UUID

```bash
sudo blkid /dev/nvme0n1p7
```

11. Add to fstab

```bash
sudo vi /etc/fstab

# Add at bottom of file
UUID=<UUID> /var/lib/longhorn xfs defaults,noatime 0 0
```

12. Apply mount

```bash
sudo systemctl daemon-reload
sudo mount -a
df -h /var/lib/longhorn
```

You should see:

~137G mounted

13. Reboot test

```bash
reboot
```

After reconnect:
```bash
df -h /var/lib/longhorn
```

FYSA: an ansible file prepare-longhorn-disk.yaml is available under ansible/rocky/prepare-longhorn-disk.yaml to perform these exact steps.

