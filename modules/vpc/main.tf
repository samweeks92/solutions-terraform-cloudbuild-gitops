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


resource "google_compute_network" "vpc" {
  project                 = var.host-project
  name                    = var.vpc-name
  auto_create_subnetworks = var.auto-create-subnetworks
}

resource "google_compute_subnetwork" "gke-subnet" {

  name                     = "gke-subnet"
  project                  = var.host-project
  ip_cidr_range            = var.gke-subnet-cidr-range
  region                   = var.region
  network                  = google_compute_network.vpc.name
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "http-server-subnet" {
  name                     = "http-server-subnet"
  project                  = var.host-project
  ip_cidr_range            = var.http-server-subnet-cidr-range
  region                   = var.region
  network                  = google_compute_network.vpc.name
  private_ip_google_access = true

}