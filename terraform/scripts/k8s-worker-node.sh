
# Initialize the Cluster:
# --pod-network-cidr=10.244.0.0/16
sudo kubeadm init 

# Set Up Local kubeconfig:
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install a Network Plugin (Calico)
sudo kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

# Generate Join Command
sudo kubeadm token create --print-join-command > /home/ubuntu/join.sh
sudo chmod +x /home/ubuntu/join.sh

