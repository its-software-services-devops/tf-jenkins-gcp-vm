variable "disk_name" {
  description = "Disk name"
  type        = string
  default     = ""
}

variable "disk_type" {
  description = "Disk name"
  type        = string
  default     = "pd-ssd"
}

variable "disk_zone" {
  description = "Disk zone"
  type        = string
  default     = ""
}

variable "disk_size_gb" {
  description = "Disk zone"
  type        = number
  default     = 10
}

variable "disk_block_size" {
  description = "Disk zone"
  type        = number
  default     = 4096
}

variable "snapshot_region" {
  description = "Snapshot region"
  type        = string
  default     = ""
}

variable "snapshot_hour_cycle" {
  description = "Snapshot in hour cycle"
  type        = number
  default     = 23
}

variable "snapshot_start_time" {
  description = "Snapshot start time"
  type        = string
  default     = "23:00"
}

variable "snapshot_retention_day" {
  description = "Day snapshot retention"
  type        = number
  default     = 7
}
