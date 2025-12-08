variable "region" {
  default = "ap-south-1"
}

variable "ami" {
  description = "Ubuntu 22.04 AMI"
  default     = "ami-02b8269d5e85954ef"
}

variable "instance_type" {
  default = "c7i-flex.large"
}

variable "key_name" {
  description = "Your SSH key in AWS"
}

variable "workers_count" {
  description = "Node count for kubernetes cluster"
  default = 2
}