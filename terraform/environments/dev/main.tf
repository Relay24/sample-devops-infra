
module "vpc" {
  source = "../../modules/vpc"

  vpc_name        = local.vpc_name
  cidr_block      = local.cidr_block
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  tags            = local.tags
}


module "eks" {
  source = "../../modules/eks"

  cluster_name    = "${local.env}-${local.eks_name}"
  cluster_version = local.eks_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  # instance_type                   = var.instance_type
  min_size                        = var.min_size
  max_size                        = var.max_size
  desired_size                    = var.desired_size
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  tags                            = local.tags
  depends_on                      = [module.vpc]
}

# module "argocd" {
#   source = "../../modules/argocd"
#
#   cluster_endpoint       = module.eks.cluster_endpoint
#   cluster_ca_certificate = module.eks.cluster_certificate_authority_data
#   cluster_auth_token     = data.aws_eks_cluster_auth.this.token
#   argocd_config_path     = "${path.module}/../../apps-config/argocd"
#   # oidc_provider_arn = module.eks.oidc_provider_arn # Больше не нужно передавать
#   region                            = local.eks_version
#   account_id                        = data.aws_caller_identity.current.account_id
#   oidc_provider_arn                 = module.eks.oidc_provider_arn
#   argocd_admin_password_secret_name = "argocd-admin-password"
#   tags                              = local.tags
# }

# module "argocd" {
#   source                 = "../../modules/argocd"
#   cluster_endpoint       = module.eks.cluster_endpoint
#   cluster_ca_certificate = module.eks.cluster_certificate_authority_data
#   cluster_auth_token     = data.aws_eks_cluster_auth.this.token
#   argocd_config_path     = "${path.module}/../../apps-config/argocd" # путь к argocd-config
#   argo_cd_values = {
#     configs = {
#       params = {
#         "server.insecure" : true
#       }
#     }
#   }
# }