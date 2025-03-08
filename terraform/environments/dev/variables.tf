variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.32"
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

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "dev-vpc"
}
