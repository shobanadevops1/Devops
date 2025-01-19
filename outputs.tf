output "location" {
  value = "westeurope"
}

output "resource_group_id" {
  value = module.ResourceGroup.resource_group_id
}

output "resource_group_name" {
  value = module.ResourceGroup.resource_group_name
}

# The following Azure AKS Outputs will be created.

output "aks_cluster_id" {
  value = module.AksCluster.cluster_id
}

output "aks_cluster_name" {
  value = module.AksCluster.cluster_name
}

output "aks_cluster_kubernetes_version" {
  value = module.AksCluster.kubernetes_version
}
