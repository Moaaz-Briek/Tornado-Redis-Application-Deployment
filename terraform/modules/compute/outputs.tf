output "vm_instance_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.management_vm.name
}

output "vm_instance_id" {
  description = "The ID of the VM instance"
  value       = google_compute_instance.management_vm.id
}

output "vm_service_account_email" {
  description = "The email of the VM service account"
  value       = google_service_account.vm_service_account.email
}
