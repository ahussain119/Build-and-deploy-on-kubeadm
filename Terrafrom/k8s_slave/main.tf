# This file contains the Terraform configuration for the k8s_slave instance.
variable "k8s_slave_ami" {}
variable "k8s_slave_sg_id" {}
variable "k8s_slave_subnet_id" {}
variable "k8s_slave_instance_type" {}
variable "key_name" {}

output "k8s_slave_ip_address" {
  value = aws_instance.k8s_slave.public_ip
}


# Creating an AWS EC2 instance resource for the k8s_slave instance
resource "aws_instance" "k8s_slave" {
  ami                         = var.k8s_slave_ami
  instance_type               = var.k8s_slave_instance_type
  key_name                    = var.key_name
  security_groups             = [var.k8s_slave_sg_id]
  subnet_id                   = var.k8s_slave_subnet_id
  associate_public_ip_address  = true
  tags = {
    Name = "k8s_slave"
  }
}
