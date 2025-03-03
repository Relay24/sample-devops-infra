variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones to use for the VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for the private subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable NAT Gateway for private subnets"
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Use a single NAT Gateway for all private subnets"
}
variable "one_nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "One nat gateway for az"
  sensitive   = false
}

variable "tags" {
  type = map(string)
  default = {}
  description = "A map of tags to add to all resources"
}