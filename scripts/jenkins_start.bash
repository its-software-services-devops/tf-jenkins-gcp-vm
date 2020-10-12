#!/bin/bash

#Disable selinux
sudo setenforce 0

CONTAINER_NAME=jenkins
IMAGE_TAG=v1.0.3

sudo docker container stop ${CONTAINER_NAME}
sudo docker container rm ${CONTAINER_NAME}

sudo docker run \
--name ${CONTAINER_NAME} \
-p 80:8080 \
-d \
-v /ext_disk1/jenkins_home:/var/jenkins_home \
itssoftware/docker-jenkins-jcasc:${IMAGE_TAG}

#-p 50000:50000 \
#--env-file ./secret.env \

