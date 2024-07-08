variable "vpc_cidr_block" {}
variable "vpc_name" {}
variable "pub_subnet_cidr_blocks" {}
variable "availability_zones" {}
variable "pri_subnet_cidr_blocks" {}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet._Pri_subnets[0].id
}

output "public_subnet_ids" {
  value = aws_subnet._Pub_subnets[0].id
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "_Pub_subnets" {
  count = length(var.pub_subnet_cidr_blocks)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.pub_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-pub-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "_Pri_subnets" {
  count = length(var.pri_subnet_cidr_blocks)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.pri_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-pri-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-rt-pub"
  }
}

resource "aws_route_table_association" "Pub2rt_association" {
  count = length(var.pub_subnet_cidr_blocks)
  subnet_id = aws_subnet._Pub_subnets[count.index].id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route" "rt_pub_default" {
  route_table_id = aws_route_table.rt_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_eip" "eip" {
  count = length(var.pri_subnet_cidr_blocks)
  tags = {
    Name = "${var.vpc_name}-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.pri_subnet_cidr_blocks)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id = aws_subnet._Pub_subnets[count.index].id
  tags = {
    Name = "${var.vpc_name}-nat-gw-${count.index + 1}"
  }
}

resource "aws_route_table" "rt_pri" {
  count = length(var.pri_subnet_cidr_blocks)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-rt-pri-${count.index + 1}"
  }
}

resource "aws_route_table_association" "Pri2rt_association" {
  count = length(var.pri_subnet_cidr_blocks)
  subnet_id = aws_subnet._Pri_subnets[count.index].id
  route_table_id = aws_route_table.rt_pri[count.index].id
}

resource "aws_route" "rt_pri_default" {
  count = length(var.pri_subnet_cidr_blocks)
  route_table_id = aws_route_table.rt_pri[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gw[count.index].id
}
