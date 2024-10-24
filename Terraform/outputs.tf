output "ec2-public-ip" {
  value = module.ec2.public-ip
  description = "Environment variable for Jenkins to use in slave configuration."
}

resource "local_file" "ansible-inventory-file-creation" {
  content  = "[local]\nlocalhost ansible_connection=local"
  filename = "${path.module}/../Ansible/${var.ansible-inventory-file-name}"
}

resource "local_file" "ansible-cfg-file-creation" {
  content  = "[defaults]\ninventory = ${var.ansible-inventory-file-name}\nprivate_key_file = ../Terraform/${var.key-pair-name}.pem\nhost_key_checking = False"
  filename = "${path.module}/../Ansible/${var.ansible-cfg-file-name}"
}

# resource "null_resource" "ansible-inventory-file-creation" {
#   provisioner "local-exec" {
#     command = <<-EOF
#       echo "[local]\nlocalhost ansible_connection=local" > ${path.module}/../Ansible/inventory.ini
#     EOF
#   }
# }

# resource "null_resource" "ansible-cfg-file-creation" {
#   provisioner "local-exec" {
#     command = <<-EOF
#       echo "[defaults]\ninventory = ${var.inventory-file-name}\nprivate_key_file = ../Terraform/${var.key-pair-name}.pem\nhost_key_checking = False" > ${path.module}/../Ansible/ansible.cfg
#     EOF
#   }
# }
