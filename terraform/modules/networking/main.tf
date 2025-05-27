# ------------------------------------------------------------------------------------------------- #
# ---------------------------------- VPC Network and Subnetworks ---------------------------------- #
# ------------------------------------------------------------------------------------------------- #

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "management_subnet" {
  name          = var.management_subnet_name
  ip_cidr_range = var.management_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "restricted_subnet" {
  name          = var.restricted_subnet_name
  ip_cidr_range = var.restricted_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# ------------------------------------------------------------------------------------------------- #
# ---------------------------------- NAT Router and NAT Gateway ----------------------------------- #
# ------------------------------------------------------------------------------------------------- #

resource "google_compute_router" "nat_router" {
  name    = var.nat_router_name
  network = google_compute_network.vpc_network.id
  region  = var.region
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = var.nat_gateway_name
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
