
resource "tls_private_key" "kube" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kube" {
  key_name   = "kube-auto-key"
  public_key = tls_private_key.kube.public_key_openssh
}

# Save private key locally
resource "local_file" "kube_private_key" {
  content         = tls_private_key.kube.private_key_pem
  filename        = "${path.module}/kube.pem"
  file_permission = "0400"
}

# Save public key locally
resource "local_file" "kube_public_key" {
  content  = tls_private_key.kube.public_key_openssh
  filename = "${path.module}/kube.pub"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# resource "aws_instance" "bastion" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.instance_type
#   subnet_id                   = aws_subnet.public_subnet.id
#   associate_public_ip_address = true
#   key_name                    = var.key_name
#   vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

#   tags = {
#     Name = "k8s-bastion"
#   }
# }


# Master Node
resource "aws_instance" "master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.kube.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = { Name = "k8s-master" }
  # depends_on = [aws_instance.workers]

  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = tls_private_key.kube.private_key_pem
  #   host        = self.public_ip
  # }

  # provisioner "file" {
  #   source      = "scripts/k8s-master-node.sh"
  #   destination = "/tmp/master.sh"
  # }

  # provisioner "file" {
  #   source      = "scripts/k8s-all-nodes.sh"
  #   destination = "/tmp/common.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo chmod +x /tmp/common.sh ",
  #     "sudo /tmp/common.sh",
  #     "sudo chmod +x /tmp/master.sh ",
  #     "sudo /tmp/master.sh"
  #   ]
  # }

}



# Worker Node
resource "aws_instance" "workers" {
  count                  = var.workers_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.kube.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = { Name = "k8s-worker-${count.index + 1}" }

  # depends_on = [aws_instance.master]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.kube.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "scripts/k8s-all-nodes.sh"
    destination = "/tmp/common.sh"
  }

  provisioner "file" {
    content     = tls_private_key.kube.private_key_pem
    destination = "/tmp/kube.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/common.sh ",
      "sudo /tmp/common.sh",
      # "scp -o StrictHostKeyChecking=no -i /tmp/kube.pem ubuntu@${aws_instance.master.private_ip}:/home/ubuntu/join.sh /tmp/"
    ]
  }

}