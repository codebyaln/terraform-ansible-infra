#!/usr/bin/env bash
set -e
TFOUT=json
terraform output -json > $TFOUT
BASTION_IP=$(jq -r '.bastion_public_ip.value' $TFOUT)
MASTER_IP=$(jq -r '.master_private_ip.value' $TFOUT)
JFROG_IP=$(jq -r '.jfrog_public_ip.value' $TFOUT)
WORKER_IPS=$(jq -r '.worker_private_ips.value[]' $TFOUT)


cat > inventory <<EOF
[bastion]
bastion ansible_host=${BASTION_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my-key.pem


[master]
master ansible_host=${MASTER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my-key.pem


[jfrog]
jfrog ansible_host=${JFROG_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my-key.pem


[workers]
EOF


i=1
for ip in ${WORKER_IPS}; do
echo "worker${i} ansible_host=${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my-key.pem" >> inventory
i=$((i+1))
done


echo "Inventory generated: ./inventory"