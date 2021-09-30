/**
 * Copyright 2021 Google LLC
 */


# GCP Host Project to deploy resources
variable "host-project" {
  type = string
}

# GCP Service Project to deploy resources
variable "service-project" {
  type = string
}

# GCP Region to deploy resources
variable "region" {
  type    = string
  default = "europe-west2"
}

# Service Account for CloudBuild in the Deployment Project, sam-sandbox-243911
variable "deploy-project-cb-sa" {
  type    = string
  default = "739789884181@cloudbuild.gserviceaccount.com"
}