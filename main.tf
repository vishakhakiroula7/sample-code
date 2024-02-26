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


#TODO: check with Satish -> firewalls? (applcation specific so add here)
#TODO: check if terraform allows flag to control which resources get created 

# for reating new service account
module "compute-vm-sa" {
 source            = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v16.0.0"
 project_id        = var.service_project_id
 name              = "${var.env}-${var.app}-compute-sa" #TODO: check with Satish
 generate_key      = false
 iam_project_roles = {
   "${var.service_project_id}" = var.compute_sa_iam_roles
 }
}

#Get the VPC and subnet data from the host project
data "google_compute_network" "compute_vm_vpc_data" {
  project = var.shared_vpc_host_project_id
  name    = var.compute_vm_host_vpc
}

# data "google_compute_subnetwork" "compute_vm_subnet_data" {
#   name    = var.compute_vm_host_vpc_subnet
#   project = var.shared_vpc_host_project_id
#   region  = var.compute_vm_host_vpc_subnet_region
# }

resource "google_compute_address" "compute_vm_internal_ips" {
 	for_each     = var.compute_vm_internal_ips
 	name         = each.key
 	subnetwork   = "projects/${var.shared_vpc_host_project_id}/regions/us-central1/subnetworks/${each.value}"
 	address_type = "INTERNAL"
 	project      = var.service_project_id #Although internal IPs use shared subnets, they need to be created in service projects
 	region       = var.int_ip_region
}


#Compute VMs for the application main resource
module "compute_vms" {
  for_each = var.compute_vm_config
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/compute-vm?ref=v16.0.0"
  project_id = var.service_project_id
  name = each.value.name
  hostname =  each.value.hostname
  zone = each.value.vm_zone
  instance_type = each.value.type
  labels = each.value.labels
  tags = var.common_vm_network_tags
  network_interfaces = [{
    network    = data.google_compute_network.compute_vm_vpc_data.self_link
    subnetwork = "projects/${var.shared_vpc_host_project_id}/regions/us-central1/subnetworks/${each.value.compute_vm_host_vpc_subnet}"
    nat        = false
    addresses  = {
        internal = google_compute_address.compute_vm_internal_ips["${each.key}-int-ip"].address
        external = null
    }
  }]
  #VM Boot Disk
  boot_disk = {
    image        = each.value.compute_boot_disk_image
    type         = each.value.compute_boot_disk_type
    size         = each.value.compute_boot_disk_size
  }
  #VM Additional Disks
    attached_disks = [
      for disk in each.value.attached_disks : {
        name        = disk.attached_disk_name
        size        = disk.attached_disk_size
        type        = disk.attached_disk_type
        source      = null
        source_type = null
        options     = null
      }
    ]
  # service_account = var.compute_sa_email_id

  # metadata = {

  #   ssh-keys = "./data/keys/srv-ansible.pub"

  # }
   #service account for VM
   service_account=module.compute-vm-sa.email
  
}


#Disk attachment for attaching snapshot schedule policy to all VM disks
resource "google_compute_disk_resource_policy_attachment" "compute_vm_boot_attachment" {
  for_each = var.compute_vm_config
  #name = google_compute_resource_policy.compute_snapshot_schedule.name
  name =  each.value.compute_snapshot_schedule_name
  disk = each.value.name
  project = var.service_project_id
  zone = each.value.vm_zone
  depends_on = [
    module.compute_vms #To avoid attachment being done before disks are created
  ]
}

#addinsnal disk

resource "google_compute_disk_resource_policy_attachment" "compute_vm_add_attachment" {
  for_each = var.compute_vm_config
  #name = google_compute_resource_policy.compute_snapshot_schedule.name
  name = each.value.compute_snapshot_schedule_name
  disk = "${each.value.name}-pd"
  project = var.service_project_id
  zone = each.value.vm_zone
  depends_on = [
    module.compute_vms #To avoid attachment being done before disks are created
  ]
}

#OPTIONAL block for App specific firewall rules
# module "app-firewall-rules" {
#   source              = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc-firewall?ref=v16.0.0"
#   project_id          = var.shared_vpc_host_project_id
#   network             = var.compute_vm_host_vpc
#   admin_ranges        = []
#   http_source_ranges  = []
#   https_source_ranges = []
#   ssh_source_ranges   = []
#   data_folder         = "${var.data_dir}/firewall-rules"
# }