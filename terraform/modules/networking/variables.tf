variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "region" {
  type        = string
  description = "The region for resources"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC network"
}

variable "management_subnet_name" {
  type        = string
  description = "Name of the management subnet"
}

variable "restricted_subnet_name" {
  type        = string
  description = "Name of the restricted subnet"
}

variable "management_subnet_cidr" {
  type        = string
  description = "CIDR range for management subnet"
}

variable "restricted_subnet_cidr" {
  type        = string
  description = "CIDR range for restricted subnet"
}

variable "nat_router_name" {
  type        = string
  description = "Name of the NAT router"
}

variable "nat_gateway_name" {
  type        = string
  description = "Name of the NAT gateway"
}
