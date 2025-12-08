
resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.k8s_sg.name]

  tags = {
    Name = "k8s-master"
  }

  # provisioner "file" {
  #   source      = "scripts/master.sh"
  #   destination = "/tmp/master.sh"

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file("~/.ssh/id_rsa")
  #     host        = self.public_ip
  #   }
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/master.sh",
  #     "sudo /tmp/master.sh"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file("~/.ssh/id_rsa")
  #     host        = self.public_ip
  #   }
  # }
}

resource "aws_instance" "workers" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.k8s_sg.name]

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }

  # provisioner "file" {
  #   source      = "scripts/worker.sh"
  #   destination = "/tmp/worker.sh"

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file("~/.ssh/id_rsa")
  #     host        = self.public_ip
  #   }
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/worker.sh",
  #     "sudo /tmp/worker.sh"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file("~/.ssh/id_rsa")
  #     host        = self.public_ip
  #   }
  # }
}