/**
 * Copyright 2021 Google LLC
 */


variable "service-project" {
  type        = string
  description = "The GCP Project name to use for the Kubernetes Cluster deployment"
}

variable "region" {
  type        = string
  description = "The GCP Region to deploy the Kubernetes Cluster in"
}

variable "cluster-name" {
  type        = string
  description = "The name to use for the GKE Cluster"

}

variable "vpc-name" {
  type        = string
  description = "The name of the VPC to create the GKE Cluster in"
}

variable "gke-subnet-name" {
  type        = string
  description = "The name to use for the GKE Subnet"
}

variable "gke-subnet-cidr-range" {
  type        = string
  description = "The CIDR range to use for the GKE Subnet"
}

variable "gke-pod-cidr-range" {
  type        = string
  description = "The CIDR Range to use for GKE Pods (VPC Native Networking)"
}

variable "gke-services-cidr-range" {
  type        = string
  description = "The CIDR Range to use for GKE Services (VPC Native Networking)"
}

variable "master-authorised-networks-list" {
  type        = map(string)
  description = "List of allowed IPv4 CIDR's that can access the GKE Master Nodes"
}

variable "master-ipv4-cidr-range" {
  type        = string
  description = "What CIDR block should be used for the GKE Masters if private clusters are enabled?"
}

variable "enable-private-nodes" {
  type        = bool
  description = "Should private GKE nodes be used with no Public IP?"
}

variable "enable-private-endpoint" {
  type        = bool
  description = "Should the master also be private and not accessible over the internet?"
}

variable "release-channel" {
  type        = string
  description = "The Kubernetes Release Channel to use"
}

variable "max-pods-per-node" {
  type = number
}

variable "autoscaling-min-nodes" {
  type        = number
  description = "The minimum number of GKE nodes for autoscaling"
}

variable "autoscaling-max-nodes" {
  type        = number
  description = "The maximum number of GKE nodes for autoscaling"
}

variable "node-machine-type" {
  type        = string
  description = "The Machine Type to use for the GKE nodes"
}

variable "disable-hpa" {
  type        = bool
  description = "Should the Horizontal Pod Autoscaling addon be disabled?"
}

variable "disable-http-load-balancing" {
  type        = bool
  description = "Should the HTTP Load Balancing addon be disabled?"
}