#================================================================! DO NOT EDIT !===============================================================#
# use `gcloud beta billing accounts list`
# if you have too many accounts, check the Cloud Console :)
#Details specific to Adtalem have already been filled. !!! DO NOT EDIT !!!
billing_account = {
    id              = "01CE59-DCE721-8E2F46"
    organization_id = 962197216585
}

# use `gcloud organizations list`
#Details specific to Adtalem have already been filled. !!! DO NOT EDIT !!!
organization = {
    domain      = "adtalem.com"
    id          = 962197216585
    customer_id = "C01gj0de0"
}
#================================================================! DO NOT EDIT !===============================================================#
#================================================================== EDITABLE ==================================================================#

#PREREQUISITE: assuming service project is added to host vpc via Landing zone code. GCP console link: https://console.cloud.google.com/networking/xpn. Select the relevant service project
service_project_id = "app-ss-prod-srv-proj"

compute_sa_email_id="infra-ss-prod-ansible-sa-mvm@infra-ss-prod-shared-srv-proj.iam.gserviceaccount.com"
#Variables for making VM and Service account resource names environment and application specific. #TODO: MENTION CHARS limit for sa name
# service_type = null
env          = "infra-ss"
app          = "adevopssha"

#IAM roles required by the custome VM service account
compute_sa_iam_roles    = [
    "roles/compute.admin",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
]

#List of static Internal IP names for required VMs. NOTE: the internal IP names should be of the format: "[VM NAME]-int-ip"
compute_vm_internal_ips = {
    cgl-adop00ap0test1-int-ip = "infra-ss-connectivity-hub-proj-vpc-ss-sb-app-ss-prod",
    cgl-adop00ap0test2-int-ip = "infra-ss-connectivity-hub-proj-vpc-ss-sb-app-ss-prod",
}
#static Internal IP region
int_ip_region = "us-central1"
compute_snapshot_schedule_region = "us-central1"

#The name of the Shared Host VPC in which VM servers need to be created
compute_vm_host_vpc = "infra-ss-connectivity-hub-proj-vpc-ss"
#The name of the Shared Host VPC Subnet in which VM servers need to be created. 
# compute_vm_host_vpc_subnet = "infra-ss-connectivity-hub-proj-vpc-ss-sb-public"
#Project ID where the Shared Host VPC lives
shared_vpc_host_project_id = "infra-ss-connectivity-hub-proj"
#The region of the Shared Host VPC Subnet
compute_vm_host_vpc_subnet_region = "us-central1"



#List of commonly used network tags that need to be applied to all VMs created using this TF template
common_vm_network_tags = ["ado-prod"]

#Configure required fields of your VM below
compute_vm_config = {
    #VM name
        cgl-adop00ap0test1 = {#APP
        #VM type
        name = "cgl-adop00ap0test1",
        #VM type
        type = "e2-medium",
        #VM hostname
        hostname = "cgl-adop00ap01.lin.adtalem.com"
        #Shared Host VPC Subnet in which VM needs to be created
        compute_vm_host_vpc_subnet = "infra-ss-connectivity-hub-proj-vpc-ss-sb-app-ss-prod"
        #VM boot disk image
        compute_boot_disk_image ="projects/infra-ss-connectivity-hub-proj/global/images/rhel-7-byos-v20220519-adtalem"
        #VM boot disk type
        compute_boot_disk_type = "pd-balanced"
        #VM boot disk size
        compute_boot_disk_size = 100
        #VM labels
        labels = {
            "application-name" = "azure-devops-sh-agent",
            "business-owner" = "wesley-weber",
            "business-unit" = "atge",
            "creator" = "terraform",
            "app-index" = "",
            "project-type"="srv",
            "institution" = "shared",
            "cost-center" = "",
            "project-name" = "azure-devops-sh-agent",
            "environment" = "prod",
            "platform" =  "redhat",
            "server-type"  = "",
            "component" = "",
            "os" = "linux7",
            "os-version" = "rhel-7",
            "loadbalancer" = "",
            "loadbalancer-name" = "",
            "app-end-user-type" = "internal",
            "serviceaccount-name" = "",
            "backup" = "dailybackup",
            "patch-window" = "",
            "power-schedule" = "",
            "compliance" = "",
            "data-classification" = "",
            "business-critical" ="",
            "app-owner"="wesley-weber",
            "database" ="",
            "it-owner" ="wesley-weber"
        }
       #List of additional disks to be attached to the VM. NOTE: the disk names should be of the format: "[VM NAME]-[DISK NAME]"
       #This is for multi Disk VMs
        attached_disks = [{
            attached_disk_name = "pd",
            attached_disk_size = 100,
            attached_disk_type = "pd-balanced"
        },
        {
            attached_disk_name = "pd2",
            attached_disk_size = 100,
            attached_disk_type = "pd-balanced"
        }
       
        ]  
        #VM zone          
        vm_zone = "us-central1-a"
        #Snapshot schedule name
        compute_snapshot_schedule_name="dailybackup"

    },
     cgl-adop00ap0test2 = {#APP
        name = "cgl-adop00ap0test2",
        type = "e2-medium",
        hostname = "cgl-adop00ap01.lin.adtalem.com"
        compute_vm_host_vpc_subnet = "infra-ss-connectivity-hub-proj-vpc-ss-sb-app-ss-prod"
        compute_boot_disk_image ="projects/infra-ss-connectivity-hub-proj/global/images/rhel-7-byos-v20220519-adtalem"
        compute_boot_disk_type = "pd-balanced"
        compute_boot_disk_size = 100
        labels = {
            "application-name" = "azure-devops-sh-agent",
            "business-owner" = "wesley-weber",
            "business-unit" = "atge",
            "creator" = "terraform",
            "app-index" = "",
            "project-type"="srv",
            "institution" = "shared",
            "cost-center" = "",
            "project-name" = "azure-devops-sh-agent",
            "environment" = "prod",
            "platform" =  "redhat",
            "server-type"  = "",
            "component" = "",
            "os" = "linux7",
            "os-version" = "rhel-7",
            "loadbalancer" = "",
            "loadbalancer-name" = "",
            "app-end-user-type" = "internal",
            "serviceaccount-name" = "",
            "backup" = "dailybackup",
            "patch-window" = "",
            "power-schedule" = "",
            "compliance" = "",
            "data-classification" = "",
            "business-critical" ="",
            "app-owner"="wesley-weber",
            "database" ="",
            "it-owner" ="wesley-weber"
        }
         
        attached_disks = [{
            attached_disk_name = "pd",
            attached_disk_size = 100,
            attached_disk_type = "pd-balanced"
        },
        {
            attached_disk_name = "pd3",
            attached_disk_size = 200,
            attached_disk_type = "pd-balanced"
        }
       
        ]
                       
        vm_zone = "us-central1-a"
        compute_snapshot_schedule_name="dailybackup"

    },
}
