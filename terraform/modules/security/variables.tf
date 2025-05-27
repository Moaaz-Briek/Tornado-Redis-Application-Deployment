variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "vpc_network_id" {
  type        = string
  description = "ID of the VPC network"
}

variable "vpc_network_name" {
  type        = string
  description = "Name of the VPC network"
}

variable "internal_cidr" {
  type        = string
  description = "Internal CIDR range for firewall rules"
}

variable "firewall_prefix" {
  type        = string
  description = "Prefix for firewall rule names"
}

variable "ssh_source_ranges" {
  type        = list(string)
  description = "Source IP ranges allowed for SSH access"
  default     = ["0.0.0.0/0"]
}
