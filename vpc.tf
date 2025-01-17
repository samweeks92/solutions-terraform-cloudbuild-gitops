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

module "vpc" {
  
  source                      = "./modules/vpc"
  
  host-project                  = var.host-project
  vpc-name                      = "tf-shared-vpc"
  gke-subnet-cidr-range         = "10.5.0.0/20"
  http-server-subnet-cidr-range = "10.6.0.0/24"
  region                        = var.region
  k8s-sa-email                  = module.gke.k8s-sa-email

}