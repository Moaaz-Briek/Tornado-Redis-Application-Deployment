# ------------------------------------------------------------------------------------------------- #
# ---------------------------------------- GKE Cluster -------------------------------------------- #
# ------------------------------------------------------------------------------------------------- #

resource "google_service_account" "gke_service_account" {
  account_id   = var.gke_service_account_name
  display_name = "GKE Service Account"
}

resource "google_project_iam_member" "gke_service_account_roles" {
  for_each = toset([
    "roles/artifactregistry.admin",
    "roles/container.nodeServiceAccount"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_service_account.email}"
}

resource "google_container_cluster" "private_gke_cluster" {
  name     = var.cluster_name
  location = var.zone

  network    = var.vpc_network_id
  subnetwork = var.restricted_subnet_name

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_cidr
    master_global_access_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.management_subnet_cidr
      display_name = "Management Subnet"
    }
  }

  node_config {
    machine_type    = var.node_machine_type
    service_account = google_service_account.gke_service_account.email
    tags            = ["gke-node"]
    disk_size_gb    = var.node_disk_size
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  initial_node_count       = var.node_count
  logging_service         = "logging.googleapis.com/kubernetes"
  monitoring_service      = "monitoring.googleapis.com/kubernetes"
  deletion_protection     = false

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}
