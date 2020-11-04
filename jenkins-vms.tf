# Run this at the beginning : export GOOGLE_CREDENTIALS="D:/dev/keys/its-artifact-commons-6eb8e8c315b3.json"

terraform {
  required_providers {
    google = "~> 3.4.0"
  }

  backend "gcs" {
    bucket  = "its-terraform-states"
    prefix  = "tf-jenkins-gcp-vm"
  }  
}

provider "google" {  
  project     = "its-artifact-commons"
  region      = "asia-southeast1"
  credentials = file("D:/dev/keys/its-artifact-commons-6eb8e8c315b3.json")
}

locals {
  zone = "asia-southeast1-b"
  region = "asia-southeast1"
  network_name = "default"
}

resource "google_compute_firewall" "jenkins-http-fw" {
  name    = "jenkins-master-allow-firewall"
  network = local.network_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["jenkins-master"]
  source_ranges = ["0.0.0.0/0"]
}


module "jenkins-master-disk-devops-00" {
  source    = "git::https://github.com/its-software-services-devops/tf-module-gcp-disk.git//modules?ref=1.0.1"
  disk_name = "jenkins-master-disk-devops-00"
  disk_zone = local.zone
  disk_size_gb = 10
  snapshot_region = local.region
}

module "jenkins-master-vm-devops-00" {
  source          = "git::https://github.com/its-software-services-devops/tf-module-gcp-vm.git//modules?ref=1.0.4"
  compute_name    = "jenkins-master-vm-devops"
  compute_seq     = "01"
  vm_tags         = ["jenkins-master"]
  vm_service_account = "devops-cicd@its-artifact-commons.iam.gserviceaccount.com"
  boot_disk_image  = "projects/centos-cloud/global/images/centos-7-v20200910"
  boot_disk_size   = 20
  public_key_file  = "D:/dev/keys/id_rsa.pub"
  private_key_file = "D:/dev/keys/id_rsa"
  vm_machine_type  = "e2-small"
  vm_machine_zone  = local.zone
  vm_deletion_protection = false
  ssh_user         = "cicd"
  provisioner_local_path  = "scripts/provisioner.bash"
  provisioner_remote_path = "/home/cicd"
  external_disks   = [{index = 1, source = module.jenkins-master-disk-devops-00.disk_id, mode = "READ_WRITE"}]
  network_configs  = [{index = 1, network = local.network_name, nat_ip = ""}] #google_compute_address.static.address
} 
