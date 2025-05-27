output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.private_gke_cluster.name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.private_gke_cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  value       = google_container_cluster.private_gke_cluster.master_auth[0].cluster_ca_certificate
}

output "gke_service_account_email" {
  description = "The email of the GKE service account"
  value       = google_service_account.gke_service_account.email
}
