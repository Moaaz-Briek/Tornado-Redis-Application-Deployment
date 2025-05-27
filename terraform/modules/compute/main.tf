# ------------------------------------------------------------------------------------------------- #
# ---------------------------------------- VM Creation -------------------------------------------- #
# ------------------------------------------------------------------------------------------------- #

data "google_compute_image" "ubuntu_image" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-2204-lts"
}

resource "google_service_account" "vm_service_account" {
  account_id   = var.vm_service_account_name
  display_name = "VM Service Account"
}

resource "google_project_iam_member" "vm_service_account_roles" {
  for_each = toset([
    "roles/container.developer",
    "roles/container.clusterAdmin",
    "roles/artifactregistry.admin",
    "roles/iam.serviceAccountUser"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vm_service_account.email}"
}

resource "google_compute_instance" "management_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
      size  = var.boot_disk_size
    }
  }

  network_interface {
    subnetwork = var.management_subnet_name
    network_ip = var.vm_internal_ip
  }

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
  tags                      = ["management-vm"]

  metadata = {
    enable-oslogin = "TRUE"
  }
}
