/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

 #Billing Account
variable "billing_account" {
  # tfdoc:variable:source 00-bootstrap
  description = "Billing account id and organization id ('nnnnnnnn' or null)."
  type = object({
    id              = string
    organization_id = number
  })
}
#Organization
variable "organization" {
  # tfdoc:variable:source 00-bootstrap
  description = "Organization details."
  type = object({
    domain      = string
    id          = number
    customer_id = string
  })
}

variable "service_project_id" {
  description = "GCP Project ID of the service project in which the new rebuild servers need to be created"
  type = string
}

variable "compute_sa_email_id" {
  description = "Pre exisisting service account for Vm servers"
  type = string
}

# variable "service_type" {
#   description = "Service GCP project typ. Possible values are: infra-ss, app-ss, etc."
#   type = string
# }

variable "env" {
  description = "Service GCP project environment. Possible values are: dev, qa, prod, nonprod, etc."
  type = string
}

variable "app" {
  description = "Service GCP project application name. Possible values are: banner, oem, ad, sccm, etc. "
  type = string
}

variable "compute_sa_iam_roles" {
  description = "The list of IAM roles required by the custom compute service account for all VMs"
  type = list(string)
}

variable "compute_vm_internal_ips" {
  description = "List of static Internal IP names for required VMs. NOTE: the internal IP names should be of the format: \"[VM NAME]-int-ip\""
  type = map(string)
}

variable "int_ip_region" {
  description = "Region of the static internal IP address. NOTE: Region should be same as the subnet in which the internal IP is being created"
  type = string
}

variable "compute_snapshot_schedule_region" {
  description = "Region in which the compute snapshot needs to be stored"
  type = string
}

variable "compute_vm_host_vpc" {
  description = "The name of the Shared Host VPC in which VM servers need to be created"
  type = string
}

# variable "compute_vm_host_vpc_subnet" {
#   description = "The name of the Shared Host VPC Subnet in which VM servers need to be created"
#   type = string
# }
variable "shared_vpc_host_project_id" {
  description = "Project ID where the Shared Host VPC lives"
  type = string
}
variable "compute_vm_host_vpc_subnet_region" {
  description = "#The region of the Shared Host VPC Subnet"
  type = string
}

# variable "common_vm_labels" {
#   description = "Map of commonly used labels that need to be applied to all VMs created using this TF template"
#   type = map(string)
# }

variable "common_vm_network_tags" {
  description = "List of commonly used network tags that need to be applied to all VMs created using this TF template"
  type = list(string)
}

#Compute Vm Config required fields configuration
variable "compute_vm_config"{
  description = "Compute VM required fields configuration"
  type = map(object({
    name = string
    type = string
    labels = map(string)
    compute_vm_host_vpc_subnet = string
    hostname = string
    compute_boot_disk_image = string
    compute_boot_disk_type= string
    compute_boot_disk_size  = number
    
    variable "attached_disks" {
      description = "List of attached disks for the VMs"
      type        = list(object({
        attached_disk_name = string
        attached_disk_size = number
        attached_disk_type = string
      }))
      default = [
        {
          attached_disk_name = "disk-1"
          attached_disk_size = 100
          attached_disk_type = "pd-standard"
        }
      ]
    }
    vm_zone = string
    compute_snapshot_schedule_name=string
    # metadata = map(string)
  }))
}

# variable "compute_boot_disk_image" {
#   description = "The boot disk image which will be commonly used by all VMs. This will be typically a generic boot disk image created for application servers"
#   type = string
# }
# variable "compute_boot_disk_type" {
#   description = "The boot disk type. Possible values can be: pd-standard, pd-balanced, pd-ssd, pd-extreme"
#   type = string
# }
# variable "compute_boot_disk_size" {
#   description = "Size of the boot disk in GB"
#   type = number
# }

variable "data_dir" {
  description = "Relative path for the folder storing configuration data for network resources like firewall rules"
  type        = string
  default     = "data"
}





