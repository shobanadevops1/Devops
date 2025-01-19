#chage 3 variable 1. var.cluster_name  & resource_group_name, 2 var.loganalytics_name 3. terrraform init tfstate file name

module "Policy"{
  source = "../Policy"
  resource_group_id = module.ResourceGroup.resource_group_id
}

module "ResourceGroup"{
  source ="../ResourceGroup"
  name = var.resource_group_name
}

module "LogAnalytics"{
  source ="../LogAnalytics"
  loganalytics_name =  var.loganalytics_name
  resource_group_name = module.ResourceGroup.resource_group_name
  environment = "test"
}

module "Identity"{
  source ="../Identity"
  identity_name = "cmcakspre001_MI"
  resource_group_name = module.ResourceGroup.resource_group_name
}

module "AksCluster"{
  source ="../AksCluster"
  aks_name = var.cluster_name
  resource_group_name = module.ResourceGroup.resource_group_name 
  environment = "test"
  node_resource_group_name = "MC_${var.resource_group_name}_${var.cluster_name}_westeurope"
  aks_version = "1.26.3"
  identity_id = module.Identity.identity_id
  vnet_subnet_id =  "/subscriptions/6402d0db-ce67-42f4-8620-7a1fc57849b6/resourceGroups/Publc-npd-rgp-001/providers/Microsoft.Network/virtualNetworks/publc-npd-vnet-002/subnets/snet-aksv2-npd-001"
  log_analytics_workspace_id = module.LogAnalytics.loganalytics_id
  ssh_public_key = var.ssh_public_key
}


resource "azurerm_kubernetes_cluster_node_pool" "fmpnodepool" {
  zones    = ["1", "2", "3"]
  enable_auto_scaling   = true
  kubernetes_cluster_id = module.AksCluster.cluster_id
  max_count             = 10   # Can increase according to our need.
  min_count             = 2
  mode                  = "User"
  name                  = "fmpnodepool"
  orchestrator_version  = "1.26.3"
  os_disk_size_gb       = 128
  os_type               = "Linux"
  vm_size               = "standard_hb120rs_v2"
  priority              = "Regular"  # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels = {
    "nodepool-type" = "user"
    "Environment"   =  "test"
    "nodepoolos"    = "linux" 
  }
  tags = {
    "nodepool-type" = "user"
    "Environment"   =  "test"
    "nodepoolos"    = "linux"
  
  }
  custom_ca_trust_enabled = false
  enable_host_encryption  = false
  enable_node_public_ip   = false
  fips_enabled            = false
  vnet_subnet_id =  "/subscriptions/6402d0db-ce67-42f4-8620-7a1fc57849b6/resourceGroups/Publc-npd-rgp-001/providers/Microsoft.Network/virtualNetworks/publc-npd-vnet-002/subnets/snet-aksv2-npd-001"
  node_taints             = [] 
}

resource "azurerm_kubernetes_cluster_node_pool" "nodepool2" {
	zones    = ["1", "2", "3"]
	enable_auto_scaling   = true
	kubernetes_cluster_id = module.AksCluster.cluster_id
	max_count             = 10   # Can increase according to our need.
	min_count             = 2
	mode                  = "User"
	name                  = "nodepool2"
	orchestrator_version  = "1.25.5"
	os_disk_size_gb       = 128
	os_type               = "Linux"
	vm_size               = "standard_d32s_v3"
	priority              = "Regular"  # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
	node_labels = {
	  "nodepool-type" = "user"
	  "Environment"   =  "test"
	  "nodepoolos"    = "linux" 
	}
	tags = {
	  "nodepool-type" = "user"
	  "Environment"   =  "test"
	  "nodepoolos"    = "linux"

	}
	custom_ca_trust_enabled = false
	enable_host_encryption  = false
	enable_node_public_ip   = false
	fips_enabled            = false
	vnet_subnet_id =  "/subscriptions/6402d0db-ce67-42f4-8620-7a1fc57849b6/resourceGroups/Publc-npd-rgp-001/providers/Microsoft.Network/virtualNetworks/publc-npd-vnet-002/subnets/snet-aksv2-npd-001"
	node_taints             = [] 
}

# This Repo is to create a cluster using terraform code

# 1. Terraform Settings Block
terraform {
  # 1. Required Version Terraform
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.37.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.31.0"
    }
  }

# Backends define where the Terraform's state snapshots are stored   Here var not allowed need to specify actual value only
   backend "azurerm" {
    resource_group_name   = "cmcks-paas-pre-rgp-005" #var.resource_group_name
    storage_account_name  = "cmcprehisec04aks001stg" #var.storage_account_name
    container_name        = "cmc-terraform" #var.container_name
    key                   = "cmcaks-pre-hisech-0011.tfstate" #var.client_key
  } 
}

# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  features {

  }
 
}


#The Kubernetes (K8S) provider is used to interact with the resources supported by Kubernetes. 
#The provider needs to be configured with the proper credentials before it can be used

provider "kubernetes" {
  host     = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].host
  username = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].username
  password = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].password
  client_certificate = base64decode(
    azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].client_certificate,
  )
  client_key = base64decode(
    azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].client_key,
  )
  cluster_ca_certificate = base64decode(
    azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].cluster_ca_certificate,
  )
}