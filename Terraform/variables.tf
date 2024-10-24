variable "region" {
  type    = string
  default = "us-east-1"
}

variable "me" {
  type    = string
  default = "Shehab"
}

data "http" "my-public-ip" {
  url = "http://checkip.amazonaws.com"
}

variable "instance-name" {
  type    = string
  default = "ansible-and-nexus-agent"
}

variable "instance-type" {
  type    = string
  default = "t3.medium"
}

variable "instance-ami" {
  type    = string
  default = "ami-0866a3c8686eaeeba"   # ami-066784287e358dad1
}

variable "key-pair-name" {
  type = string
  default = "nexus-task-aws-pvkey"
}

variable "ansible-inventory-file-name" {
  type = string
  default = "inventory.ini"
}

variable "ansible-cfg-file-name" {
  type = string
  default = "ansible.cfg"
}
