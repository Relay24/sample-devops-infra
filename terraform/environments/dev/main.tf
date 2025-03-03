data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  env         = "dev"
  region      = "us-east-1"
  vpc_name    = "my-dev-vpc"
  eks_name    = "my-dev-eks"
  eks_version = "1.32"

  cidr_block    = "10.0.0.0/16"
  az_count      = 2
  azs         = slice(data.aws_availability_zones.available.names, 0, local.az_count) # ["us-east-1a", "us-east-1b"]

  public_subnet_newbits  = 6  # /22 (1024) : 22 - 16 = 6
  private_subnet_newbits = 2 # /18 (16384) : 18 - 16 = 2
  public_subnets  = [for i, az in local.azs : cidrsubnet(local.cidr_block, local.public_subnet_newbits, i + 100)] # ["10.0.0.0/18", "10.0.64.0/18"]
  private_subnets = [for i, az in local.azs : cidrsubnet(local.cidr_block, local.private_subnet_newbits, i)] # ["10.0.128.0/22", "10.0.132.0/22"]

  tags = {
    Environment = local.env
  }
}


module "vpc" {
  source = "../../modules/vpc"

  vpc_name        = var.vpc_name
  cidr_block      = var.cidr_block
  azs             = local.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  tags            = var.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name                    = "${local.env}-${local.eks_name}"
  cluster_version                 = local.eks_version
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnet_ids
  instance_type                   = var.instance_type
  min_size                        = var.min_size
  max_size                        = var.max_size
  desired_size                    = var.desired_size
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  tags                            = var.tags
}

# module "argocd" {
#   source = "../../modules/argocd"
#   cluster_endpoint = module.eks.cluster_endpoint
#   cluster_ca_certificate = module.eks.cluster_certificate_authority_data
#   cluster_auth_token = module.eks.cluster_auth_token
#   argocd_config_path = "${path.module}/../../apps-config/argocd" # путь к argocd-config
#   argo_cd_values = {
#     configs = {
#       params = {
#         "server.insecure" : true
#       }
#     }
#   }
# }