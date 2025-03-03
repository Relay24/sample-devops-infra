data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  env         = "dev"
  region      = "us-east-1"
  vpc_name    = "dev-vpc"
  eks_name    = "my-eks-cluster"
  eks_version = "1.32"

  cidr_block = "10.0.0.0/16"
  az_count   = 2
  azs        = slice(data.aws_availability_zones.available.names, 0, local.az_count)

  az_blocks       = [for i in range(local.az_count) : cidrsubnet(local.cidr_block, 1, i)]
  public_subnets  = [for i, az in local.azs : cidrsubnet(local.az_blocks[i], 5, 0)] # 2 x 1024
  private_subnets = [for i, az in local.azs : cidrsubnet(local.az_blocks[i], 3, 1)] # 2 x 16384

  tags = {
    Environment = local.env
  }
}
