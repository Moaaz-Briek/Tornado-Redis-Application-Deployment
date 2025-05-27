output "firewall_rule_names" {
  description = "Names of created firewall rules"
  value = [
    google_compute_firewall.allow_internal.name,
    google_compute_firewall.allow_ssh_management.name,
    google_compute_firewall.allow_health_checks.name,
    google_compute_firewall.allow_gke_node_ports.name
  ]
}
