# This file contains the variables that are used in the main.tf file
# define the variables
vpc_cidr_block         = "10.0.0.0/16"
vpc_name               = "kuber"
pub_subnet_cidr_blocks = ["10.0.1.0/24"]
pri_subnet_cidr_blocks = ["10.0.2.0/24"]
availability_zones     = ["ca-central-1a"]

ami     = "ami-0c9f6749650d5c0e3"
ami_k8s = "ami-017384b28a13571a1"

jenkins_instance_type   = "t2.medium"
docker_instance_type    = "t2.medium"
k8s_instance_type       = "t3.medium"
k8s_slave_instance_type = "t2.medium"

domain_name = "aaqibhussain.link"

sshkey = "jenkins"
