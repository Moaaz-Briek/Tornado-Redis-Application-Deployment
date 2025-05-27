output "vpc_network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "vpc_network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "management_subnet_name" {
  description = "The name of the management subnet"
  value       = google_compute_subnetwork.management_subnet.name
}

output "restricted_subnet_name" {
  description = "The name of the restricted subnet"
  value       = google_compute_subnetwork.restricted_subnet.name
}

output "management_subnet_id" {
  description = "The ID of the management subnet"
  value       = google_compute_subnetwork.management_subnet.id
}

output "restricted_subnet_id" {
  description = "The ID of the restricted subnet"
  value       = google_compute_subnetwork.restricted_subnet.id
}
