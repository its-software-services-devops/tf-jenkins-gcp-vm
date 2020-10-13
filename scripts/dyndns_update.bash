#!/bin/bash -x

HOSTNAME=$(hostname)
PARAM_FILE=${HOSTNAME}.params

gsutil cp "gs://its-config-params/cicd/${PARAM_FILE}" .
source ${PARAM_FILE}

USERNAME="${DYNDNS_USERNAME}"
PASSWORD="${DYNDNS_PASSWORD}"
DNS=jenkins-devops.its-software-services.com

IP=`gcloud compute instances describe ${HOSTNAME} \
--format='get(networkInterfaces[0].accessConfigs[0].natIP)' \
--zone=asia-southeast1-b`

curl -v "https://${USERNAME}:${PASSWORD}@domains.google.com/nic/update?hostname=${DNS}&myip=${IP}"
