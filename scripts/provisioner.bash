#!/bin/bash

USER=cicd
SCRIPT_PATH=/home/${USER}

DEVICE_PATH=/dev/sdb
MOUNTED_POINT=/ext_disk1
FSTAB=/etc/fstab

sudo mkdir -p ${MOUNTED_POINT}

#TODO : Check if file system already exist, if yes then skip mkfs
sudo blkid ${DEVICE_PATH}
if [ $? -eq 0 ]
then
  echo "File system is already created, skip to preserve the existing data."
else
  echo "This is brand new disk, will make new file system."
  sudo mkfs -F -t ext4 ${DEVICE_PATH}
fi
sudo mount ${DEVICE_PATH} ${MOUNTED_POINT}

sudo chmod 666 ${FSTAB}
sudo cat << EOF >> /etc/fstab
${DEVICE_PATH}    ${MOUNTED_POINT}        ext4    defaults    0 2
EOF
sudo chmod 644 ${FSTAB}

sudo mkdir -p ${MOUNTED_POINT}/jenkins_home
sudo chown ${USER} ${MOUNTED_POINT}
sudo chown ${USER} ${MOUNTED_POINT}/jenkins_home

#sudo yum update -y

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

chmod 755 ${SCRIPT_PATH}/jenkins_check.bash
chmod 755 ${SCRIPT_PATH}/jenkins_start.bash
chmod 755 ${SCRIPT_PATH}/dyndns_update.bash

${SCRIPT_PATH}/jenkins_start.bash
${SCRIPT_PATH}/dyndns_update.bash

echo "*/1 * * * * ${SCRIPT_PATH}/jenkins_check.bash" | sudo crontab -u ${USER} -
echo "*/1 * * * * ${SCRIPT_PATH}/dyndns_update.bash" | sudo crontab -u ${USER} -