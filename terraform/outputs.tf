output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "worker_private_ips" {
  value = [for w in aws_instance.workers : w.private_ip]
}

output "jfrog_public_ip" {
  value = aws_instance.jfrog.public_ip
}

output "gitlab_runner_public_ip" {
  value = aws_instance.gitlab_runner.public_ip
}

output "ssh_key_name" {
  value = aws_key_pair.main.key_name
}
