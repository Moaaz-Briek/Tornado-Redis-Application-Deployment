variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "zone" {
  type        = string
  description = "The zone for the VM instance"
}

variable "vm_name" {
  type        = string
  description = "Name of the VM instance"
}

variable "vm_service_account_name" {
  type        = string
  description = "Name of the VM service account"
}

variable "management_subnet_name" {
  type        = string
  description = "Name of the management subnet"
}

variable "vm_internal_ip" {
  type        = string
  description = "Internal IP address for the VM"
}

variable "machine_type" {
  type        = string
  description = "Machine type for the VM"
  default     = "e2-medium"
}

variable "boot_disk_size" {
  type        = number
  description = "Boot disk size in GB"
  default     = 50
}
