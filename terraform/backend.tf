terraform {
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "k8s-infra/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile  = true
  }
}

