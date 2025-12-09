#!/bin/bash
# set -e

# # Disable swap
# swapoff -a
# sed -i '/swap/d' /etc/fstab

# # Install dependencies
# apt-get update -y
# apt-get install -y apt-transport-https ca-certificates curl

# # Install containerd
# apt-get install -y containerd
# mkdir -p /etc/containerd
# containerd config default > /etc/containerd/config.toml
# systemctl restart containerd

# # Install Kubernetes
# curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" \
#   > /etc/apt/sources.list.d/kubernetes.list

# apt-get update
# apt-get install -y kubelet kubeadm kubectl
# apt-mark hold kubelet kubeadm kubectl

# Initialize cluster
kubeadm init --pod-network-cidr=10.244.0.0/16

# Setup kubectl
mkdir -p /home/ubuntu/.kube
cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

# Install network (Flannel)
su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"

# Generate join command
# kubeadm token create --print-join-command > /home/ubuntu/join.sh
# chmod +x /home/ubuntu/join.sh

JOIN_CMD=$(kubeadm token create --print-join-command)

echo "sudo $JOIN_CMD --cri-socket \"unix:///run/containerd/containerd.sock\" --v=5" \
  > /home/ubuntu/join.sh
chmod +x /home/ubuntu/join.sh
