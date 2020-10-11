#!/bin/bash

USER=cicd
SCRIPT_PATH=/home/${USER}

#sudo yum update -y

#sudo yum check-update
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

#sudo yum install java-1.8.0-openjdk -y
#java -version

chmod 755 ${SCRIPT_PATH}/jenkins_check.bash
chmod 755 ${SCRIPT_PATH}/jenkins_start.bash

${SCRIPT_PATH}/jenkins_start.bash

echo "*/1 * * * * ${SCRIPT_PATH}/jenkins_check.bash" | sudo crontab -u ${USER} -