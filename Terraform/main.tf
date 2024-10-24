module "vpc" {
  source     = "./Modules/vpc"
  name       = "nexus-task-vpc"
  cidr-block = "10.0.0.0/16"
  created-by = var.me
}

module "pb-subnet" {
  source            = "./Modules/subnet"
  name-and-cidr     = ["nexus-task-pb-subnet", "10.0.0.0/24"]
  availability-zone = "us-east-1a"
  created-by        = var.me
  vpc-id            = module.vpc.id
}

module "igw" {
  source     = "./Modules/internet_gateway"
  name       = "nexus-task-igw"
  created-by = var.me
  vpc-id     = module.vpc.id
}

module "pb-rtb" {
  source     = "./Modules/public_route_table"
  name       = "nexus-task-pb-rtb"
  created-by = var.me
  vpc-id     = module.vpc.id
  igw-id     = module.igw.id
}

module "public-associations" {
  source     = "./Modules/route_table_association"
  subnet-ids = [module.pb-subnet.id]
  rtb-id     = module.pb-rtb.id
}

module "key-pair" {
  source   = "./Modules/key_pair"
  key-name = var.key-pair-name
}

module "secgrp" {
  source      = "./Modules/security_group"
  secgrp-name = "nexus-task-secgrp"
  created-by  = var.me
  vpc-id      = module.vpc.id
  ingress-data = [
    # Allow port 22 for SSH connection from your IP, and port 8081 for Nexus access.
    #   To get the public IP we will use a data block at `variables.tf` that executes a URL of an API that replies with the IP.
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["${trimspace(data.http.my-public-ip.response_body)}/32"], security_groups = [] },
    { from_port = 8081, to_port = 8081, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups = [] }
  ]
  egress-data = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
}

module "ec2" {
  source                 = "./Modules/aws_linux_ec2_user_data"
  created-by             = var.me
  aws-linux-instance-ami = var.instance-ami
  instance-name          = var.instance-name
  instance-type          = var.instance-type
  subnet-id              = module.pb-subnet.id
  secgrp-id              = module.secgrp.id
  key-name               = var.key-pair-name
  user-data              = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y openjdk-11-jre
  EOF
}
