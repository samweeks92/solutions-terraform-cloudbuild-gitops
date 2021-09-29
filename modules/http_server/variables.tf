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


variable "project" {
  type        = string
  description = "The GCP Project name to use for the VPC deployment"
}

variable "region" {
  type        = string
  description = "The GCP Region to deploy the Kubernetes Cluster in"
}

variable "vpc-name" {
  type        = string
  description = "The name of the network to use"
}

variable "subnet-name" {
  type        = string
  description = "The name of the subnetwork to use"
}