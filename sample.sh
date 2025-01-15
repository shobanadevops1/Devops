nss=$(kubectl get ns | awk '{print $1}')
for ns in $nss
do
  echo "**********************"
  echo "images in $ns"
  pods=$(kubectl get pods -n $ns | awk '{print $1}')
  for pod in $pods
  do
    kubectl describe pod $pod -n $ns | grep -i image:
  done

done
