terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_address" "postgres_standby" {
  name         = "postgres-standby-ip"
  address_type = "INTERNAL"
  region       = var.region
  subnetwork   = var.subnetwork

  address = var.standby_ip
}

resource "google_compute_firewall" "postgresql_replication" {
  name    = "allow-postgresql-replication"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["5433"]
  }

  source_ranges = [
    "${var.primary_ip}/32"
  ]

  target_tags = [
    "postgresql-standby"
  ]
}

resource "google_compute_instance" "postgres_standby" {

  name         = "postgresql-standby"
  machine_type = "e2-medium"

  zone = var.zone

  tags = [
    "postgresql-standby"
  ]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 30
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    network_ip = google_compute_address.postgres_standby.address
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = <<-EOF
#!/bin/bash

set -e

apt-get update

apt-get install -y \
  postgresql-16 \
  postgresql-client-16

systemctl enable postgresql

systemctl start postgresql

echo "PostgreSQL 16 installation completed" \
  > /var/log/postgresql-terraform-install.log

EOF
}
