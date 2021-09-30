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


// Output the VPC Name
output "vpc-name" {
  value = google_compute_network.tf-shared-vpc.name
}

// Output the Self Link URL
output "vpc-self-link" {
  value = google_compute_network.tf-shared-vpc.self_link
}

// Output the vpc id
output "vpc-id" {
  value = google_compute_network.tf-shared-vpc.id
}

// Output the gke subnet name
output "gke-subnet-name" {
  value = google_compute_subnetwork.gke-subnet.name
}

// Output the gke subnet range
output "gke-subnet-cidr-range" {
  value = google_compute_subnetwork.gke-subnet.ip_cidr_range
}