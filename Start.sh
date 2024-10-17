#!/bin/bash

docker rm jenkins-container-for-installing-nexus

# docker rmi jenkins-image-for-installing-nexus

# docker build . -t jenkins-image-for-installing-nexus

docker run -d \
  --name jenkins-container-for-installing-nexus \
  -p 8080:8080 \
  -p 50000:50000 \
  -v ~/Desktop/jenkins-data:/var/jenkins_home \
  -v /usr/bin/terraform:/usr/bin/terraform \
  -v ~/.aws:/root/.aws \
  -v /usr/bin/git:/usr/bin/git \
  -u root \
  jenkins-image-for-installing-nexus
