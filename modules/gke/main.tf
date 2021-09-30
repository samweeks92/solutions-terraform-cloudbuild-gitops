/**
 * Copyright 2021 Google LLC
 */

#k8s service account
resource "google_service_account" "k8s" {
  project    = var.service-project
  account_id = "k8s-sa"
}

# Create the GKE Cluster
resource "google_container_cluster" "gke" {
  name     = var.cluster-name
  location = var.region
  project  = var.service-project

  networking_mode = "VPC_NATIVE"
  network         = var.vpc-name
  subnetwork      = var.gke-subnet-name

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke-secondary-pods-range-name
    services_secondary_range_name = var.gke-secondary-services-range-name
  }

  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = true
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  workload_identity_config {
    identity_namespace = "${var.service-project}.svc.id.goog"
  }

}

resource "google_container_node_pool" "linux-vm" {
  name       = "linux-vm"
  location   = var.region
  cluster    = google_container_cluster.gke.name
  project    = var.service-project
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      role = "linux"
    }
    machine_type = "e2-medium"

    service_account = google_service_account.k8s.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Run this local-exec on every single run to generate Kubectl credentials
# resource "null_resource" "kube-creds" {

#   depends_on = [google_container_cluster.gke-cluster]

#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = "gcloud container clusters get-credentials ${google_container_cluster.gke-cluster.name} --region=${google_container_cluster.gke-cluster.location} --project=${var.service-project}"
#   }

# }