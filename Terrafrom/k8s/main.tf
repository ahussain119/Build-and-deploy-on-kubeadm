# This file contains the Terraform configuration for the k8s instance.
variable "k8s_ami" {}
variable "k8s_sg_id" {}
variable "k8s_subnet_id" {}
variable "k8s_instance_type" {}
variable "key_name" {}

output "k8s_ip_address" {
  value = aws_instance.k8s.private_ip
}


# Creating an AWS EC2 instance resource for the k8s instance
resource "aws_instance" "k8s" {
  ami                         = var.k8s_ami
  instance_type               = var.k8s_instance_type
  key_name                    = var.key_name
  security_groups             = [var.k8s_sg_id]
  subnet_id                   = var.k8s_subnet_id
  tags = {
    Name = "k8s"
  }
  root_block_device {
    volume_size = 20
  }
}
