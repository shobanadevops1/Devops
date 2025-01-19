variable "cluster_name" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "cmcaks-pre-0011" 
}
variable "loganalytics_name" {
  type = string
  description = "log analytics workspace name"
  default = "cmcaks-preprod-loganalyticsws-002"
}

# SSH Public Key for Linux VMs this field is mandatory
variable "ssh_public_key" {
  default = "~/id_rsa.pub"
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"  
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
  description = "This variable defines the Resource Group"
  default = "cmcks-paas-pre-rgp-001"
}