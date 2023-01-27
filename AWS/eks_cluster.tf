# EKS IAM Cluster Role

resource "aws_iam_role" "eks_role" {
  name               = var.eks_iam_role_name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = {
      Effect    = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }
  })

}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}



# EKS IAM Node Role

resource "aws_iam_role" "node_instance_role" {
  name               = var.eks_nodes
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = {
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_instance_profile" "node_instance_profile" {
  name = var.eks_nodes
  role = aws_iam_role.node_instance_role.name
}

# Creates VPC called Main with 2 public subnets and 2 private subnets

resource "aws_vpc" "main" {
  cidr_block = var.vpc_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.eks_cluster_name}-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}



resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_01_block
map_public_ip_on_launch = true
availability_zone = "us-west-2a"
tags = {
Name = "${var.eks_cluster_name}-Public-Subnet-01"
}
}

resource "aws_subnet" "public_subnet_02" {
vpc_id = aws_vpc.main.id
cidr_block = var.public_subnet_02_block
map_public_ip_on_launch = true
availability_zone = "us-west-2b"
tags = {
Name = "${var.eks_cluster_name}-Public-Subnet-02"
}
}

resource "aws_subnet" "private_subnet_01" {
vpc_id = aws_vpc.main.id
cidr_block = var.private_subnet_01_block
map_public_ip_on_launch = false
availability_zone = "us-west-2a"
tags = {
Name = "${var.eks_cluster_name}-Private-Subnet-01"
}
}

resource "aws_subnet" "private_subnet_02" {
vpc_id = aws_vpc.main.id
cidr_block = var.private_subnet_02_block
map_public_ip_on_launch = false
availability_zone = "us-west-2b"
tags = {
Name = "${var.eks_cluster_name}-Private-Subnet-02"
}
}

resource "aws_route_table" "public_route_table" {
vpc_id = aws_vpc.main.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
}
tags = {
Name = "${var.eks_cluster_name}-Public-Route-Table"
}
}

resource "aws_route_table_association" "public_subnet_01_assoc" {
subnet_id = aws_subnet.public_subnet_01.id
route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_02_assoc" {
subnet_id = aws_subnet.public_subnet_02.id
route_table_id = aws_route_table.public_route_table.id
}

# Create NAT Gateway and Associate Private subnets

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.private_subnet_01.id
  depends_on = [aws_internet_gateway.gw]
}


# Creates Security Group for the EKS Cluster

resource "aws_security_group" "eks_cluster_sg" {
name = "${var.eks_cluster_name}-SG"
description = "Security group for EKS cluster"
vpc_id = aws_vpc.main.id
ingress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}


# Creates the EKS Cluster and attaches 2 pub subnet and 2 private subnets        \\
# Private subnets will be used for the K8s nodes and Public will be used for the load balancer 


resource "aws_eks_cluster" "eks_cluster" {
name = var.eks_cluster_name
depends_on = [
aws_iam_role.eks_role,
aws_vpc.main,
]
role_arn = aws_iam_role.eks_role.arn
vpc_config {
subnet_ids = [
aws_subnet.public_subnet_01.id,
aws_subnet.public_subnet_02.id,
aws_subnet.private_subnet_01.id,
aws_subnet.private_subnet_02.id
]
security_group_ids = [aws_security_group.eks_cluster_sg.id]

}
}

# Creates EKS Node group 

resource "aws_eks_node_group" "eks_node_group" {
cluster_name = aws_eks_cluster.eks_cluster.name
node_group_name = var.eks_nodes
node_role_arn = aws_iam_role.node_instance_role.arn
instance_types = ["t3.xlarge"]
scaling_config {
desired_size = 1
max_size = 1
min_size = 1
}
disk_size = 50
subnet_ids = [aws_subnet.public_subnet_01.id, aws_subnet.public_subnet_01.id]
depends_on = [
  aws_iam_instance_profile.node_instance_profile,
  aws_iam_role.node_instance_role,
 ]
}


