FROM jenkins/jenkins:lts

WORKDIR /home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform

COPY . .

USER root

RUN apt-get update
RUN apt-get install -y git

EXPOSE 8080
