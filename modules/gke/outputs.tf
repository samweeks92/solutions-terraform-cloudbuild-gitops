/**
 * Copyright 2021 Google LLC
 */


// Google Client Config contains credentials for accessing the GKE Cluster
data "google_client_config" "default" {}

// Output the endpoint of the GKE Master
output "kubernetes-endpoint" {
  value = google_container_cluster.gke.endpoint
}

// Output the Client Token from the default google_client_config data source above
output "client-token" {
  sensitive = true
  value     = data.google_client_config.default.access_token
}

// Output the CA Certificate from the GKE Cluster
output "ca-certificate" {
  value     = google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  sensitive = true
}

// Output the GKE Cluster Name
output "cluster-name" {
  description = "The name of the cluster"
  value       = google_container_cluster.gke.name
}

// Output the GKE Cluster Region Name
output "cluster-region" {
  description = "The region of the cluster"
  value       = google_container_cluster.gke.location
}

output "k8s-sa-email" {
  description = "The k8s service account email"
  value       = google_service_account.k8s.email
}