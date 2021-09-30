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
  name                    = var.vpc-name
  project                 = var.host-project
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL" #CHANGED
  mtu                     = 1500
}

resource "google_compute_subnetwork" "gke-subnet" {
  name                     = "gke-subnet"
  project                  = var.host-project
  ip_cidr_range            = var.gke-subnet-cidr-range
  region                   = var.region
  network                  = google_compute_network.tf-shared-vpc.self_link
  private_ip_google_access = true

  secondary_ip_range {
      range_name    = "gke-pods-cidr-range"
      ip_cidr_range = "10.0.0.0/14"
    }
  secondary_ip_range {
      range_name    = "gke-services-cidr-range"
      ip_cidr_range = "10.4.0.0/19"
    }
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  project = var.host-project
  network = google_compute_network.tf-shared-vpc.self_link
}

resource "google_compute_router_nat" "mist_nat" {
  name                                = "nat"
  project                             = var.host-project
  router                              = google_compute_router.router.name
  region                              = var.region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  depends_on = [google_compute_subnetwork.gke-subnet]
}


resource "google_compute_subnetwork_iam_binding" "subnetwork-iam-binding" {
  project = var.host-project
  region = var.region
  subnetwork = google_compute_subnetwork.gke-subnet.name

  role = "roles/compute.networkUser"

  members = [
    "serviceAccount:473776704087@cloudservices.gserviceaccount.com",
    "serviceAccount:service-473776704087@container-engine-robot.iam.gserviceaccount.com",
    "serviceAccount:${var.k8s-sa-email}",
  ]
}


resource "google_project_iam_binding" "container-engine-iam-binding" {
  project = var.host-project
  role = "roles/compute.networkUser"

  members = [
    "serviceAccount:service-473776704087@container-engine-robot.iam.gserviceaccount.com"
  ]
}