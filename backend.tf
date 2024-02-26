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

#Backend bucket required for storing Terraform state
#Each stage has its own state file with the appropriate prefix
#This bucket resides in the "infra-ss-landing-zone-tf" GCP project

terraform {
  backend "gcs" {
    # The name of the bucket
    bucket = ""
      # The prefix is the path inside the bucket
    prefix = ""


  }
}
