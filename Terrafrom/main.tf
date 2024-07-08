module "networking" {
  source                 = "./networking"
  vpc_cidr_block         = var.vpc_cidr_block
  vpc_name               = var.vpc_name
  pri_subnet_cidr_blocks = var.pri_subnet_cidr_blocks
  pub_subnet_cidr_blocks = var.pub_subnet_cidr_blocks
  availability_zones     = var.availability_zones
}

module "security_groups" {
  source = "./security-groups"
  vpc_id = module.networking.vpc_id
  project_name = var.vpc_name
}

module "jenkins" {
  source                = "./jenkins"
  jenkins_ami           = var.ami
  jenkins_instance_type = var.jenkins_instance_type
  jenkins_sg_id         = module.security_groups.jenkins_sg_id
  jenkins_subnet_id     = module.networking.public_subnet_ids
  key_name              = var.sshkey
}

module "docker" {
  source               = "./docker"
  docker_ami           = var.ami
  docker_instance_type = var.docker_instance_type
  docker_sg_id         = module.security_groups.docker_sg_id
  docker_subnet_id     = module.networking.private_subnet_ids
  key_name             = var.sshkey
}

module "k8s" {
  source            = "./k8s"
  k8s_ami           = var.ami
  k8s_instance_type = var.k8s_instance_type
  k8s_sg_id         = module.security_groups.kubernetes_sg_id
  k8s_subnet_id     = module.networking.private_subnet_ids
  key_name          = var.sshkey
}

module "k8s_slave" {
  source                  = "./k8s_slave"
  k8s_slave_ami           = var.ami
  k8s_slave_instance_type = var.k8s_slave_instance_type
  k8s_slave_sg_id         = module.security_groups.kubernetes_slave_sg_id
  k8s_slave_subnet_id     = module.networking.public_subnet_ids
  key_name                = var.sshkey
}

module "route53" {
  source             = "./route53"
  domain_name        = var.domain_name
  jenkins_ip_address = module.jenkins.jenkins_ip_address
  docker_ip_address  = module.docker.docker_ip_address
  k8s_ip_address     = module.k8s.k8s_ip_address
  k8s_slave_ip_address = module.k8s_slave.k8s_slave_ip_address
}

