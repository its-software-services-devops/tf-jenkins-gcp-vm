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

resource "google_compute_address" "static" {
  name = "public-ip-001"
}

resource "google_compute_disk" "disk00" {
  name  = "jenkins-master-vm-devops-disk"
  type  = "pd-ssd"
  zone  = "asia-southeast1-b"
  physical_block_size_bytes = 4096
}

module "jenkins-master-vm-devops-00" {
  source          = "git::https://github.com/its-software-services-devops/tf-module-gcp-vm.git//modules?ref=1.0.1"
  compute_name    = "jenkins-master-vm-devops"
  compute_seq     = "00"
  vm_tags         = ["jenkins-master", "http-server"]
  vm_service_account = "devops-cicd@its-artifact-commons.iam.gserviceaccount.com"
  default_ip_address = google_compute_address.static.address
  boot_disk_image  = "projects/centos-cloud/global/images/centos-7-v20200910"
  public_key_file  = "D:/dev/keys/id_rsa.pub"
  private_key_file = "D:/dev/keys/id_rsa"
  vm_machine_type  = "e2-micro"
  vm_machine_zone  = "asia-southeast1-b"
  ssh_user         = "cicd"
  provisioner_local_path  = "provisioner.bash"
  provisioner_remote_path = "/home/cicd/provisioner.bash"
  external_disks   = [{index = 1, source = google_compute_disk.disk00.id, mode = "READ_WRITE"}]
  network_configs  = [{index = 1, network = "default", nat_ip = google_compute_address.static.address}]
}