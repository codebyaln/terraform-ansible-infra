
# scp -i ".\baas-exp.pem" ".\baas-exp.pem" ubuntu@ec2-13-232-73-97.ap-south-1.compute.amazonaws.com:/home/ubuntu

sudo chown -R $USER:$USER .
sudo chmod -R 755 .

rm -rf .terraform
terraform init

terraform import aws_key_pair.main baas-exp

# resource "aws_key_pair" "main" {
#   key_name = "baas-exp"
# }

# Remove the bad attribute from state
terraform state rm aws_key_pair.main.public_key

terraform plan

terraform state show aws_key_pair.main

# Remove the key pair entry from state completely (safe)
terraform state rm aws_key_pair.main


aws ec2 describe-key-pairs --region ap-south-1

# terraform import aws_key_pair.main mykey

# aws ec2 describe-key-pairs --key-names "baas-exp"

aws ec2 describe-instance-types --filters Name=free-tier-eligible,Values=true

sudo ssh-keygen -y -f baas-exp.pem > baas-exp.pub

terraform init -reconfigure

terraform init -migrate-state

terraform output -json > ../ansible/terraform-outputs.json

terraform output -json > tfout.json
