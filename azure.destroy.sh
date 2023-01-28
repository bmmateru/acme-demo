#!/bin/bash

# Change to nginx-app directory

cd /Users/wosia/Documents/acme-demo/nginx-app

echo " Decommisioning of nginx app is in progress. Get some coffee and enjoy the ride!"

# Run terraform destroy with auto-approve flag

terraform destroy --auto-approve

# Wait for nginx app to be destroyed

status="Running"
while [ "$status" != "Destroy complete!" ]
do
output=$(terraform show -json)
if [ -z "$output" ]; then
  echo "Error: No resources to destroy"
  exit 1
else
  status=$(echo $output | jq '.planned_values.root_module.resources[].destroy_complete')
  echo "Cluster has been destroyed"
fi
echo "Nginx app has been destroyed"

# Navigate to Azure Directory
# check if there is output on the jq command to proceed but if its empy to error out with resource destroyed

cd /Users/wosia/Documents/acme-demo/Azure

terraform destroy --auto-approve
output=$(terraform show -json)
if [ -z "$output" ]; then
  echo "Error: No resources to destroy"
  exit 1
else
  status=$(echo $output | jq '.planned_values.root_module.resources[].destroy_complete')
  echo "Cluster has been destroyed"
fi
sleep 5
done

