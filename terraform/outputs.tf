output "vpc_network_id" {
  description = "The ID of the VPC network"
  value       = module.networking.vpc_network_id
}

output "management_subnet_name" {
  description = "The name of the management subnet"
  value       = module.networking.management_subnet_name
}

output "restricted_subnet_name" {
  description = "The name of the restricted subnet"
  value       = module.networking.restricted_subnet_name
}

output "vm_instance_name" {
  description = "The name of the management VM instance"
  value       = module.compute.vm_instance_name
}

output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "gke_cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "artifact_registry_url" {
  description = "The URL of the Artifact Registry repository"
  value       = module.registry.repository_url
}
