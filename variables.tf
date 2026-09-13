variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "asia-south1-a"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-south1"
}

variable "network" {
  description = "Existing VPC network"
  type        = string
}

variable "subnetwork" {
  description = "Existing subnet"
  type        = string
}

variable "standby_ip" {
  description = "Static internal IP for PostgreSQL standby"
  type        = string
  default     = "10.88.0.5"
}

variable "primary_ip" {
  description = "Existing PostgreSQL primary IP"
  type        = string
  default     = "10.88.0.4"
}

variable "ssh_user" {
  description = "Linux SSH user"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private key"
  type        = string
  sensitive   = true
}

variable "replication_password" {
  description = "PostgreSQL replication user password"
  type        = string
  sensitive   = true
}
