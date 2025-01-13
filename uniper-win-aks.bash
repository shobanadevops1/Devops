az account set --subscription 6402d0db-ce67-42f4-8620-7a1fc57849b6

az aks create --resource-group cmcwind-paas-pre-rgp-001 \
--kubernetes-version 1.23.5 \
--name cmcwin-pre-003 --generate-ssh-keys --enable-managed-identity --assign-identity /subscriptions/6402d0db-ce67-42f4-8620-7a1fc57849b6/resourcegroups/cmcwind-paas-pre-rgp-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/cmcwin-pre-003-MI \
--node-count 2 \
--enable-cluster-autoscaler \
--min-count 2 \
--max-count 6 \
--network-plugin azure \
--service-cidr 192.168.0.0/16 \
--dns-service-ip 192.168.1.10 \
--docker-bridge-address 172.22.0.1/29 \
--vnet-subnet-id "/subscriptions/6402d0db-ce67-42f4-8620-7a1fc57849b6/resourceGroups/Publc-npd-rgp-001/providers/Microsoft.Network/virtualNetworks/publc-npd-vnet-001/subnets/publc-npd-snet-aks-azurecni-003" \
--enable-aad \
--aad-admin-group-object-ids 55a16f7a-c144-4d36-a9ff-3540b32641d0 \
--aad-tenant-id db8e2f82-8a37-4c09-b7de-ed06547b5a20 \
--node-osdisk-size 128 \
--node-vm-size Standard_DS2_v2 \
--nodepool-labels nodepool-type=system nodepoolos=linux app=system-apps \
--nodepool-name systempool \
--nodepool-tags nodepool-type=system nodepoolos=linux app=system-apps \
--tags "EAM_ID=20062" "Environment=pre" "Environment=preprod" "Owner=SchmitzCarsten" "Owner_Email=carsten.schmitz@uniper.energy" \
--enable-addons monitoring \
--outbound-type userDefinedRouting \
--enable-ahub \
--zones {1,2,3} \
--network-policy calico \
--node-resource-group cmcwin-paas-pre-rgp-003 \
--windows-admin-username azure \
--windows-admin-password 'replacePassword1234$' \
--max-pods 100 \
--workspace-resource-id /subscriptions/6402d0db-ce67-42f4-8620-7a1fc57849b6/resourcegroups/cmcwind-paas-pre-rgp-001/providers/microsoft.operationalinsights/workspaces/cmcwin-pre-003-workspace




====================================================================================
az aks nodepool add --resource-group ${AKS_RESOURCE_GROUP} \
                    --cluster-name ${AKS_CLUSTER} \
                    --name linux \
                    --node-count 1 \
                    --enable-cluster-autoscaler \
                    --max-count 5 \
                    --min-count 1 \
                    --mode User \
                    --node-vm-size Standard_DS2_v2 \
                    --os-type Linux \
                    --labels nodepool-type=user nodepoolos=linux app=managed-apps \
                    --tags "EAM_ID=20062" "Environment=pre" "Environment=preprod" "Owner=SchmitzCarsten" "Owner_Email=carsten.schmitz@uniper.energy"  \
                    --zones {1,2,3}
====================================================================================




AKS_RESOURCE_GROUP=vamshi-aks-prod
AKS_CLUSTER=vamshiaksprod
az aks nodepool add \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --cluster-name $AKS_CLUSTER \
	--mode user \
    --os-type Windows \
    --name npwin \
	--node-vm-size standard_d32s_v3 \
	--enable-cluster-autoscaler \
    --tags "EAM_ID=20062" "Environment=pre" "Environment=preprod" "Owner=SchmitzCarsten" "Owner_Email=carsten.schmitz@uniper.energy" \
	--min-count 1 \
    --max-count 3 \
    --node-count 1 \
	--node-osdisk-size 200 \
	--max-pods 100
	

	
	
	
	
kured
kubecost
qualys

network policies


==============================================================

