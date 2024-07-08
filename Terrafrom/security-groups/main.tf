# This Terraform configuration file creates security groups in the VPC:
variable "vpc_id" {}
variable "project_name" {}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_ec2_sg.id
}
output "docker_sg_id" {
  value = aws_security_group.docker_ec2_sg.id
}
output "kubernetes_sg_id" {
  value = aws_security_group.kubernetes_ec2_sg.id
}
output "kubernetes_slave_sg_id" {
  value = aws_security_group.kubernetes_slave_ec2_sg.id
}

# Creating an EC2 security group
resource "aws_security_group" "jenkins_ec2_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-ec2-sg-22-8080"
  }
}

# Creating a Docker security group
resource "aws_security_group" "docker_ec2_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Docker-ec2-sg-22"
  }
}

# Creating a kubernetes security group
resource "aws_security_group" "kubernetes_ec2_sg" { 
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Kubernetes-ec2-sg-22-6443"
  }
}

# Creating a kubernetes slave security group
resource "aws_security_group" "kubernetes_slave_ec2_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Kubernetes-Slave-ec2-sg-22"
  }
}

