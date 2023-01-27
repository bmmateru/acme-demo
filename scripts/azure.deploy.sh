#!/bin/bash

# Change to Azure  directory
cd /Users/wosia/Desktop/acme-demo/ACME/Azure

echo "Cluster is Creating. Feel free to grab a coffee and Enjoy the Ride"

# Run terraform apply with auto-approve flag
terraform apply --auto-approve
status="Running"
while [ "$status" != "Apply complete!" ]
do
terraform apply --auto-approve
output=$(terraform show -json)
if [ -n "$output" ]; then
echo "Resources have been Deployed to Azure"

# Update KubeConfig 

mv /Users/wosia/Desktop/acme-demo/ACME/Azure/kubeconfig ~/.kube/config

sleep 3

# Navigate to Nginx App Directory

cd /Users/wosia/Desktop/acme-demo/ACME/nginx-app

# Run terraform apply with auto-approve flag

terraform apply --auto-approve
kubectl get pods --namespace nginx-app
if [ -n "$(kubectl get pods --namespace nginx-app -o json)" ]; then
echo "App Deployed"
loadBalancerIP=$(kubectl get svc --namespace nginx-app nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
loadBalancerPort=$(kubectl get svc --namespace nginx-app nginx-service -o jsonpath='{.spec.ports[0].port}')
echo "Access the app at http://$loadBalancerIP:$loadBalancerPort"
fi
else
status=$(echo $output | jq '.planned_values.root_module.resources[].apply_complete')
fi
sleep 1

#Ending Script

exit 0

done



