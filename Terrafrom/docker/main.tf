# This file contains the Terraform configuration for the docker instance.
variable "docker_ami" {}
variable "docker_sg_id" {}
variable "docker_subnet_id" {}
variable "docker_instance_type" {}
variable "key_name" {}

output "docker_ip_address" {
    value = aws_instance.docker.private_ip
}

# Creating an AWS EC2 instance resource for the docker instance
resource "aws_instance" "docker" {
    ami                          = var.docker_ami
    instance_type                = var.docker_instance_type
    key_name                     = var.key_name
    security_groups              = [var.docker_sg_id]
    subnet_id                    = var.docker_subnet_id
    tags = {
        Name = "docker"
    }
}