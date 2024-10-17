FROM jenkins/jenkins:lts

WORKDIR /home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform

COPY . .

EXPOSE 8080
