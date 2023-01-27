# ACME Demo - Terraform Cloud


## Directory Structure

- AWS: This directory contains scripts and configuration files for deploying a VPC with 2 public and 2 private subnets, and creating an EKS cluster with a node group that is exposed in a load balancer.
- Azure: This directory contains scripts and configuration files for creating a basic AKS cluster with a load balancer that exposes the app inside the cluster.
- nginx: This directory contains scripts and configuration files for deploying an nginx app into the Kubernetes cluster.
- Scripts: This directory contains 2 files for each cloud provider, one for deploying (aws.deploy.sh and azure.deploy.sh) and one for destroying (aws.destroy.sh and azure.destroy.sh)

### Prerequisites

Requirements for the script to work:
- Export AWS and Azure Creds as Environment Varibales


### Deployment

To deploy on AWS, navigate to the AWS directory and run the command:

```
cd scripts
bash aws.deploy.sh

```

To destroy the deployment, run the command:

```
cd scripts
bash aws.destroy.sh

````

To deploy on Azure, navigate to the Azure directory and run the command:

```
cd scripts
bash azure.deploy.sh

```

To destroy the deployment, run the command:

```
cd scripts
bash azure.destroy.sh

```


## Testing 

Get the output "Access URL" then open it up on your browser
