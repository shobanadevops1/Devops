$SourceAcrName="unipercontainerregistry"
$DestinationAcrName="uniperbackup"


$Repos="wats"

foreach ($repo in $Repos) {
    $Tags = az acr repository show-tags -n $SourceAcrName --repository $repo | ConvertFrom-Json
    foreach ($tag in $Tags) {
		
		az acr import   --name $DestinationAcrName   --source unipercontainerregistry.azurecr.io/"${repo}:${tag}"   --image "${repo}:${tag}"  --username unipercontainerregistry  --password LPc3dT4s/NzWlKxW3DHB32Y+B=0gHTYE
    }
}
