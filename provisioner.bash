#!/bin/bash

sudo yum update -y

sudo yum check-update
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

sudo yum install java-1.8.0-openjdk -y
java -version 