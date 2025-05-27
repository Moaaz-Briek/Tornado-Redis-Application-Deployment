# Project Configuration
variable "project_id" {
  type        = string
  description = "The Google Cloud project ID where resources will be deployed"
}

variable "region" {
  type        = string
  description = "The region where resources will be deployed"
}

variable "zone" {
  type        = string
  description = "The zone where resources will be deployed"
}

# Networking Variables
variable "vpc_name" {
  type        = string
  description = "Name of the VPC network"
  default     = "enterprise-vpc"
}

variable "management_subnet_name" {
  type        = string
  description = "Name of the management subnet"
  default     = "mgmt-subnet"
}

variable "restricted_subnet_name" {
  type        = string
  description = "Name of the restricted subnet"
  default     = "restricted-subnet"
}

variable "management_subnet_cidr" {
  type        = string
  description = "CIDR range for management subnet"
  default     = "192.168.10.0/24"
}

variable "restricted_subnet_cidr" {
  type        = string
  description = "CIDR range for restricted subnet"
  default     = "192.168.20.0/24"
}

variable "internal_cidr" {
  type        = string
  description = "Internal CIDR range for firewall rules"
  default     = "192.168.0.0/16"
}

variable "nat_router_name" {
  type        = string
  description = "Name of the NAT router"
  default     = "enterprise-nat-router"
}

variable "nat_gateway_name" {
  type        = string
  description = "Name of the NAT gateway"
  default     = "enterprise-nat-gateway"
}

# Compute Variables
variable "vm_name" {
  type        = string
  description = "Name of the management VM"
  default     = "management-vm"
}

variable "vm_service_account_name" {
  type        = string
  description = "Name of the VM service account"
  default     = "vm-service-account"
}

variable "vm_internal_ip" {
  type        = string
  description = "Internal IP address for the management VM"
  default     = "192.168.10.100"
}

# GKE Variables
variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
  default     = "enterprise-gke-cluster"
}

variable "gke_service_account_name" {
  type        = string
  description = "Name of the GKE service account"
  default     = "gke-service-account"
}

variable "master_cidr" {
  type        = string
  description = "CIDR range for GKE master nodes"
  default     = "172.20.0.0/28"
}

variable "node_count" {
  type        = number
  description = "Initial number of GKE nodes"
  default     = 2
}

# Registry Variables
variable "repository_name" {
  type        = string
  description = "Name of the Artifact Registry repository"
  default     = "enterprise-docker-repo"
}

# Security Variables
variable "firewall_prefix" {
  type        = string
  description = "Prefix for firewall rule names"
  default     = "enterprise"
}
