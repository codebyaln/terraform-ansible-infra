
output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "worker_private_ips" {
  value = aws_instance.workers[*].private_ip
}
