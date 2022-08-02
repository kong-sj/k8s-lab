#!/bin/bash

read -p "Worker Node 대수 " number

array=()

for ((i=0; i<$number; i++))
do

                echo "Worker Node$i의 IP 주소를 입력해주세요"
                echo "($i)worker node ip: "
                read nodeip
                array+=($nodeip )

done


# init K8s
sudo kubeadm init --token-ttl 0  > kubeadm-init-result.txt

# token saved at k8s-token.txt
cat kubeadm-init-result.txt | tail -2 > k8s-token.sh

sudo rm kubeadm-init-result.txt

# config for master only
# Master get kubectl privileges
mkdir -p $HOME/.kube
sudo rm -f $HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# config Calico network
curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# Master node join
for ((j=0; j<${#array[@]}; j++))
do
        scp ~/k8s-token.sh root@${array[j]}:/home
        echo -e "\n"
        ssh ${array[j]} /bin/bash /home/k8s-token.sh
        echo -e "\n"

done
