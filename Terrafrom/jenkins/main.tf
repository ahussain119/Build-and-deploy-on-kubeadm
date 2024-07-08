# This file contains the Terraform configuration for the jenkins instance.
variable "jenkins_ami" {}
variable "jenkins_sg_id" {}
variable "jenkins_subnet_id" {}
variable "jenkins_instance_type" {}
variable "key_name" {}

output "jenkins_ip_address" {
    value = aws_instance.jenkins.public_ip
}


# Creating an AWS EC2 instance resource for the jenkins instance
resource "aws_instance" "jenkins" {
    ami                          = var.jenkins_ami
    instance_type                = var.jenkins_instance_type
    key_name                     = var.key_name
    security_groups              = [var.jenkins_sg_id]
    subnet_id                    = var.jenkins_subnet_id
    associate_public_ip_address  = true
    tags = {
        Name = "jenkins"
    }
}