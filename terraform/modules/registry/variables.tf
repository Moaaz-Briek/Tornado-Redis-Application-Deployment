variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "region" {
  type        = string
  description = "The region for the repository"
}

variable "repository_name" {
  type        = string
  description = "Name of the Artifact Registry repository"
}

variable "environment" {
  type        = string
  description = "Environment label"
  default     = "dev"
}
