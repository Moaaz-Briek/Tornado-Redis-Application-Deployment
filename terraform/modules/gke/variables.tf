variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "zone" {
  type        = string
  description = "The zone for the GKE cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "gke_service_account_name" {
  type        = string
  description = "Name of the GKE service account"
}

variable "vpc_network_id" {
  type        = string
  description = "ID of the VPC network"
}

variable "restricted_subnet_name" {
  type        = string
  description = "Name of the restricted subnet"
}

variable "master_cidr" {
  type        = string
  description = "CIDR range for GKE master nodes"
}

variable "management_subnet_cidr" {
  type        = string
  description = "CIDR range for management subnet"
}

variable "node_count" {
  type        = number
  description = "Initial number of GKE nodes"
}

variable "node_machine_type" {
  type        = string
  description = "Machine type for GKE nodes"
  default     = "e2-medium"
}

variable "node_disk_size" {
  type        = number
  description = "Disk size for GKE nodes in GB"
  default     = 50
}
