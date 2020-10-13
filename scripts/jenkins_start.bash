#!/bin/bash +x

#Disable selinux
sudo setenforce 0

HOSTNAME=$(hostname)
PARAM_FILE=${HOSTNAME}.params
ENV_FILE=${HOSTNAME}.env

gsutil cp "gs://its-config-params/cicd/${PARAM_FILE}" ${ENV_FILE}
source ${ENV_FILE}


CONTAINER_NAME=jenkins
IMAGE_TAG=${JENKINS_IMAGE_TAG}

sudo docker container stop ${CONTAINER_NAME}
sudo docker container rm ${CONTAINER_NAME}

sudo docker run \
--name ${CONTAINER_NAME} \
-p 80:8080 \
-d \
-v /ext_disk1/jenkins_home:/var/jenkins_home \
--env-file ./${ENV_FILE} \
itssoftware/docker-jenkins-jcasc:${IMAGE_TAG}

#-p 50000:50000 \
#--env-file ./secret.env \

