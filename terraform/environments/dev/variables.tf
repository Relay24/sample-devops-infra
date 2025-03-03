variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "az_count" {
  type        = number
  description = "Number of availability zones to use."
}

variable "private_subnets" {
  type = list(string)
  description = "CIDR blocks for the private subnets"
}

variable "public_subnets" {
  type = list(string)
  description = "CIDR blocks for the public subnets"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "instance_type" {
  type        = string
  description = "Default instance type for node group."
  default     = "t3.medium"
}

variable "min_size" {
  type        = number
  description = "Minimum size of the node group."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum size of the node group."
  default     = 3
}

variable "desired_size" {
  type        = number
  description = "Desired size of the node group."
  default     = 1
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
  default = {}
  description = "A map of tags to add to all resources"
}