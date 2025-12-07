
aws_region = "ap-south-1"

key_name         = "baas-exp"
public_key_path  = "baas-exp.pem"

ssh_allowed_cidr = "0.0.0.0/0"


# - t3.small 2GB
# - c7i-flex.large 4GB
# - m7i-flex.large 8GB
# - t4g.micro 1GB
# - t4g.small 2GB
instance_type = "t3.small"
bastion_instance_type = "t3.small"
gitlab_runner_instance_type = "c7i-flex.large"
jfrog_instance_type = "c7i-flex.large"

workers_count = 3
