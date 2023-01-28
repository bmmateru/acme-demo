output "subnet_ids" {
  value = join(",", [aws_subnet.public_subnet_01.id, aws_subnet.public_subnet_02.id, aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id])
  description = "Subnets IDs in the VPC"
}


output "vpc_id" {
  value = aws_vpc.main.id
  description = "The VPC Id"
}

output "node_group" {
  value = aws_eks_node_group.eks_node_group.node_group_name
  description = "The current cluster managed node group"
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
  description = "The name of the EKS cluster"
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
  description = "The endpoint of the EKS cluster"
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
  description = "The ARN of the EKS cluster"
}