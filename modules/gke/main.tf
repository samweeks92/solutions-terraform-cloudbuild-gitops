/**
 * Copyright 2021 Google LLC
 */


# Create the GKE Cluster
resource "google_container_cluster" "gke-cluster" {

  // Temporarily use the google-beta provider as networking_mode is a beta flag
  provider = google-beta

  project                   = var.service-project
  name                      = var.cluster-name
  location                  = var.region
  default_max_pods_per_node = var.max-pods-per-node
  network                   = var.vpc-name
  networking_mode           = "VPC_NATIVE"
  remove_default_node_pool  = true
  initial_node_count        = 1
  subnetwork                = var.gke-subnet-name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke-secondary-pods-range-name
    services_secondary_range_name = var.gke-secondary-services-range-name
  }

  master_authorized_networks_config {

    // Dynamically populate from input map
    dynamic "cidr_blocks" {
      for_each = var.master-authorised-networks-list
      content {
        cidr_block   = cidr_blocks.value
        display_name = cidr_blocks.key
      }
    }

  }

  private_cluster_config {
    enable_private_nodes    = var.enable-private-nodes
    enable_private_endpoint = var.enable-private-endpoint
    master_ipv4_cidr_block  = var.master-ipv4-cidr-range

    master_global_access_config {
      enabled = var.enable-private-endpoint
    }

  }

  release_channel {
    channel = var.release-channel
  }

#   workload_identity_config {
#     identity_namespace = "${var.service-project}.svc.id.goog"
#   }

  addons_config {

    horizontal_pod_autoscaling {
      disabled = var.disable-hpa
    }

    http_load_balancing {
      disabled = var.disable-http-load-balancing
    }

  }

}

# Add the primary NodePool
resource "google_container_node_pool" "linux-nodepool" {

  name     = "linux-nodepool"
  location = var.region

  autoscaling {
    min_node_count = var.autoscaling-min-nodes
    max_node_count = var.autoscaling-max-nodes
  }

  initial_node_count = (var.autoscaling-min-nodes / 3)
  max_pods_per_node  = var.max-pods-per-node
  cluster            = google_container_cluster.gke-cluster.name

  node_config {
    preemptible  = false
    machine_type = var.node-machine-type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
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