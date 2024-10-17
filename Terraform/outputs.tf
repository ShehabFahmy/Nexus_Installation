resource "local_file" "inventory-file" {
  content  = "[ansible-and-nexus-agent]\n${module.ec2.public-ip}"
  filename = "${path.module}/../Ansible/${var.inventory-file-name}"
}

resource "null_resource" "ansible-cfg-creation" {
  provisioner "local-exec" {
    command = <<-EOF
      echo "[defaults]\ninventory = ${var.inventory-file-name}\nprivate_key_file = ${var.key-pair-name}.pem\nhost_key_checking = False" > ${path.module}/../Ansible/ansible.cfg
    EOF
  }
}
