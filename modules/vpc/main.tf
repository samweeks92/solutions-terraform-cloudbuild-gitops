# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


resource "google_compute_network" "tf-shared-vpc" {
  project                 = var.host-project
  name                    = var.vpc-name
  auto_create_subnetworks = var.auto-create-subnetworks
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "gke-subnet" {

  name                     = "gke-subnet"
  project                  = var.host-project
  ip_cidr_range            = var.gke-subnet-cidr-range
  region                   = var.region
  network                  = google_compute_network.tf-shared-vpc.name
  private_ip_google_access = true

  secondary_ip_range {
      range_name    = "gke-pods-cidr-range"
      ip_cidr_range = "10.0.0.0/14"
    }
  secondary_ip_range {
      range_name    = "gke-services-cidr-range"
      ip_cidr_range = "10.4.0.0/20"
    }
}


resource "google_compute_subnetwork_iam_member" "gke-subnet-member-cloudservices" {
  project = var.host-project
  region = var.region
  subnetwork = google_compute_subnetwork.gke-subnet.name
  role = "roles/compute.networkUser"
  member = "serviceAccount:473776704087@cloudservices.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "gke-subnet-member-container-engine" {
  project = var.host-project
  region = var.region
  subnetwork = google_compute_subnetwork.gke-subnet.name
  role = "roles/compute.networkUser"
  member = "serviceAccount:service-473776704087@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "host-project-compute-security-admin" {
  project = var.host-project
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:service-473776704087@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "host-project-host-service-agent-user" {
  project = var.host-project
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:service-473776704087@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_compute_subnetwork" "http-server-subnet" {
  name                     = "http-server-subnet"
  project                  = var.host-project
  ip_cidr_range            = var.http-server-subnet-cidr-range
  region                   = var.region
  network                  = google_compute_network.tf-shared-vpc.name
  private_ip_google_access = true
}

resource "google_compute_subnetwork_iam_member" "http-server-member-cloudservices" {
  project = var.host-project
  region = var.region
  subnetwork = google_compute_subnetwork.http-server-subnet.name
  role = "roles/compute.networkUser"
  member = "serviceAccount:473776704087@cloudservices.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "http-server-subnet-member-container-engine" {
  project = var.host-project
  region = var.region
  subnetwork = google_compute_subnetwork.http-server-subnet.name
  role = "roles/compute.networkUser"
  member = "serviceAccount:service-473776704087@container-engine-robot.iam.gserviceaccount.com"
}