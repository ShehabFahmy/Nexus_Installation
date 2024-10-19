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

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "instance-ami" {
  type    = string
  default = "ami-0866a3c8686eaeeba"   # ami-066784287e358dad1
}

variable "key-pair-name" {
  type = string
  default = "nexus-task-key-pair"
}

variable "inventory-file-name" {
  type = string
  default = "inventory.ini"
}
