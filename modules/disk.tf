terraform {
  required_providers {
    google = "3.4.0"
  }
}

resource "google_compute_disk" "disk" {
  name  = var.disk_name
  type  = var.disk_type #"pd-ssd"
  zone  = var.disk_zone #local.zone
  size  = var.disk_size_gb
  physical_block_size_bytes = var.disk_block_size #4096
}

resource "google_compute_resource_policy" "policy" {
  name   = "snapshot-policy"
  region = var.snapshot_region
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = var.snapshot_hour_cycle
        start_time     = var.snapshot_start_time #"23:00"
      }
    }

    retention_policy {
      max_retention_days    = var.snapshot_retention_day
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.policy.name
  disk = google_compute_disk.disk.name
  zone = var.disk_zone
}
