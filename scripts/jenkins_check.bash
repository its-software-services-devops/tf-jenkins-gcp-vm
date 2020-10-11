#!/bin/bash

PS_NAME=jenkins
CONTAINER_NAME=$(sudo docker ps --format "{{.Names}}" | grep ${PS_NAME})
SCRIPT_PATH=/home/cicd

if [ "${CONTAINER_NAME}" = "" ]; then
    ${SCRIPT_PATH}/jenkins_start.bash
    echo "$(date)" >> ${SCRIPT_PATH}/jenkins_restart.log
fi
