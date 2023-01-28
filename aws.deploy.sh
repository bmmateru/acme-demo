#!/bin/bash

# Change to AWS directory
cd /Users/wosia/Documents/acme-demo/AWS

echo "Cluster is Creating. Feel free to grab a coffee and Enjoy the Ride"

# Run terraform apply with auto-approve flag
terraform init 

sleep 5 

terraform plan 

sleep 5

terraform apply --auto-approve

status="Running"
while [ "$status" != "Apply complete!" ]
do
terraform apply --auto-approve
output=$(terraform show -json)
if [ -n "$output" ]; then
echo "Resources have been Deployed"

aws eks --region us-west-2 update-kubeconfig --name bmateru-eks-cluster
sleep 3

cd /Users/wosia/Documents/acme-demo/nginx-app
# Run terraform apply with auto-approve flag

terraform init 

sleep 5 


terraform apply --auto-approve
kubectl get pods --namespace nginx-app
if [ -n "$(kubectl get pods --namespace nginx-app -o json)" ]; then
echo "App Deployed"
loadBalancerIP=$(kubectl get svc --namespace nginx-app nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
loadBalancerPort=$(kubectl get svc --namespace nginx-app nginx-service -o jsonpath='{.spec.ports[0].port}')
echo "Access the app at http://$loadBalancerIP:$loadBalancerPort"
fi
else
status=$(echo $output | jq '.planned_values.root_module.resources[].apply_complete')
fi
sleep 1
exit 0
done



