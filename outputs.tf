output "standby_instance_name" {
  value = google_compute_instance.postgres_standby.name
}

output "standby_internal_ip" {
  value = google_compute_address.postgres_standby.address
}

output "primary_ip" {
  value = var.primary_ip
}

output "replication_target" {
  value = "${var.primary_ip}:5432"
}
