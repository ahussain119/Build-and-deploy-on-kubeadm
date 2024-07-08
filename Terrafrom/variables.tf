variable "vpc_name" {
    description = "The name of the VPC"
    type = string
}

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type = string
}

variable "pub_subnet_cidr_blocks" {
    description = "The CIDR blocks for the public subnets"
    type = list(string)
}

variable "pri_subnet_cidr_blocks" {
    description = "The CIDR blocks for the private subnets"
    type = list(string)
}

variable "availability_zones" {
    description = "The availability zones for the subnets"
    type = list(string)
}

variable "ami" {
    description = "The AMI ID for the instances"
    type = string  
}

variable "ami_k8s" {
    description = "The AMI ID for the Kubernetes instances"
    type = string
}

variable "jenkins_instance_type" {
    description = "The instance type for the Jenkins instance"
    type = string
}

variable "docker_instance_type" {
    description = "The instance type for the Docker instance"
    type = string
}

variable "k8s_instance_type" {
    description = "The instance type for the Kubernetes master instance"
    type = string
}

variable "k8s_slave_instance_type" {
    description = "The instance type for the Kubernetes slave instance"
    type = string
}

variable "domain_name" {
    description = "The domain name for the Route53 records"
    type = string
}

variable "sshkey" {
    description = "The name of the SSH key pair"
    type = string
}