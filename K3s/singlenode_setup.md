<h1> Setup single node practice lab </h1>

# command
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="\
--cluster-init \
--data-dir /srv/k3s \
--node-ip 192.168.31.50 \
--advertise-address 192.168.31.50 \
--bind-address 192.168.31.50 \
--tls-san 192.168.31.50 \
--write-kubeconfig-mode 644" sh -
```

downloads script and setup the k3s as systemd component

define data dir for etcd at /srv/k3s
master advertise listener and nodeip -- 102.168.31.50
and bind a particular interface
update the ca.cert subject alternative name with 192.168.31.50
and writee kubeconfig but grant 644 role on linux


``` bash
kubectl get nodes -o wide

kubectl get nodes -o wide
NAME       STATUS   ROLES                AGE     VERSION        INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
master-1   Ready    control-plane,etcd   9m11s   v1.34.4+k3s1   192.168.31.50   <none>        Ubuntu 24.04.3 LTS   6.8.0-1047-raspi   containerd://2.1.5-k3s1 
```