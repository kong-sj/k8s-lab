#!/bin/bash

if [[ "$1" == "reset" ]]
        then
                apt-mark unhold kubelet kubeadm kubectl
                yes | sudo kubeadm reset
                systemctl restart kubelet
                apt purge kubeadm -y
                apt purge kubelet -y
                apt purge kubectl -y
                rm -rf ~/.kube/
                rm -rf /etc/kubernetes/
#               exit 1
fi


# Config docker drivergroup
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

#Restart docker
systemctl daemon-reload
systemctl restart docker

# install kubernetes cluster
swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF


apt-get update
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


apt-get update

# echo "============================"
# echo "Enter the user K8s Version"
# echo "version: " (원하는 버전이 있을 경우 해당라인부터 주석 해제)
# read version
# version=$version"-00"
# echo "Entered Version: $version"
version="1.21.10-00"
echo "============================"
echo "Install start"
echo "============================"


# install kubelet, kubeadm, kubectl
apt install -y kubelet=${version} kubeadm=${version} kubectl=${version}


# version hold
apt-mark hold kubelet kubeadm kubectl


sysctl --system
