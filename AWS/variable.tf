
variable "eks_iam_role_name" {
type = string
default = "bmateru-eks-cluster-role"
}

variable "eks_nodes" {
type = string
default = "bmateru-eks-managed-nodes"
}

variable "eks_cluster_name" {
type = string
default = "bmateru-eks-cluster"
}

variable "vpc_block" {
type = string
default = "10.0.0.0/16"
}

variable "public_subnet_01_block" {
type = string
default = "10.0.0.0/24"
}

variable "public_subnet_02_block" {
type = string
default = "10.0.1.0/24"
}

variable "private_subnet_01_block" {
type = string
default = "10.0.2.0/24"
}

variable "private_subnet_02_block" {
type = string
default = "10.0.3.0/24"
}

variable "ec2_ssh_key" {
  type        = string
  default     = ".wosia.pem"
}

