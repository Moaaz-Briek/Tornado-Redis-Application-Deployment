# ------------------------------------------------------------------------------------------------- #
# ---------------------------------------- Firewall Rules ----------------------------------------- #
# ------------------------------------------------------------------------------------------------- #

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.firewall_prefix}-allow-internal"
  network = var.vpc_network_name

  direction     = "INGRESS"
  priority      = 65534
  source_ranges = [var.internal_cidr]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  target_tags = ["internal"]
}

resource "google_compute_firewall" "allow_ssh_management" {
  name    = "${var.firewall_prefix}-allow-ssh-management"
  network = var.vpc_network_name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = var.ssh_source_ranges
  target_tags   = ["management-vm"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "${var.firewall_prefix}-allow-health-checks"
  network = var.vpc_network_name

  direction = "INGRESS"
  priority  = 1000
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  target_tags = ["gke-node"]
}

resource "google_compute_firewall" "allow_gke_node_ports" {
  name    = "${var.firewall_prefix}-allow-gke-node-ports"
  network = var.vpc_network_name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.internal_cidr]

  target_tags = ["gke-node"]

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
}
