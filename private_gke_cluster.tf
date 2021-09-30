/**
 * Copyright 2021 Google LLC
 */

# Create the primary GKE Cluster that will be used for services such as Directus and Drools
module "gke" {

  # Set Source
  source = "./modules/gke"

  # General Config
  service-project             = var.service-project
  region                      = var.region
  cluster-name                = "bss-cluster"
  enable-private-nodes        = true
  enable-private-endpoint     = false
  release-channel             = "STABLE"
  max-pods-per-node           = 20
  autoscaling-min-nodes       = 3
  autoscaling-max-nodes       = 10
  node-machine-type           = "e2-standard-8"
  disable-hpa                 = false
  disable-http-load-balancing = false

  # Network Config
  vpc-name                          = module.vpc.vpc-name
  # vpc-name                          = "shared-vpc"
  gke-subnet-name                   = module.vpc.gke-subnet-name
  # gke-subnet-name                   = "subnet1"
  gke-secondary-pods-range-name     = "gke-pods-cidr-range"
  gke-secondary-services-range-name = "gke-services-cidr-range"
  # gke-secondary-pods-range-name     = "subnet1-pods"
  # gke-secondary-services-range-name = "subnet1-sevices"
  master-authorised-networks-list   = { "allow-all" : "0.0.0.0/0" } # Required so Cloud Build can access GKE
  master-ipv4-cidr-range            = "172.16.0.32/28"

}