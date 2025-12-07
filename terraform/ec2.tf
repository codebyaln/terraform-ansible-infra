# data "local_file" "public_key" {
#   filename = var.public_key_path
# }

# resource "aws_key_pair" "main" {
#   key_name   = var.key_name
#   public_key = data.local_file.public_key.content
# }

# Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Bastion
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.bastion_instance_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "bastion" }
}

# Master Node
resource "aws_instance" "master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s_nodes.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "k8s-master" }
}

# Worker Nodes
resource "aws_instance" "workers" {
  count                  = var.workers_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[1].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s_nodes.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "k8s-worker-${count.index + 1}" }
}

# JFrog Server
resource "aws_instance" "jfrog" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.jfrog_instance_type
  subnet_id              = aws_subnet.public[1].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.jfrog_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "jfrog" }
}

# GitLab Runner
resource "aws_instance" "gitlab_runner" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.gitlab_runner_instance_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "gitlab-runner" }
}
