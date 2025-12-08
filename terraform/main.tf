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
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  # iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "k8s-master" }

  provisioner "file" {
    source      = "scripts/master.sh"
    destination = "/tmp/master.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/ubuntu/kube.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/master.sh",
      "sudo /tmp/master.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

}

# Worker Node
resource "aws_instance" "workers" {
  count                  = var.workers_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  # iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "k8s-worker-${count.index + 1}" }
}