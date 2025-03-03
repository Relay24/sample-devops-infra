variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the worker nodes"
  default     = "t3.medium"
}

variable "min_size" {
  type = number
  description = "Minimum size of the node group."
  default = 1
}

variable "max_size" {
  type = number
  description = "Maximum size of the node group."
  default = 3
}

variable "desired_size" {
  type = number
  description = "Desired size of the node group."
  default = 1
}

variable "cluster_endpoint_public_access" {
  type = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type = bool
  default = false
}

variable "tags" {
  type = map(string)
  default = {}
  description = "A map of tags to add to all resources"
}

# (Optional) Add variables for IRSA, node group configuration, etc.