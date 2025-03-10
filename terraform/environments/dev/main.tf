# --- VPC ---
module "vpc" {
  source          = "../../modules/vpc"
  vpc_name        = local.vpc_name
  cidr_block      = local.cidr_block
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  tags            = local.tags
}

# --- EKS ---
module "eks" {
  source          = "../../modules/eks"
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
}

# --- ArgoCD ---
module "argocd" {
  source           = "../../modules/argocd"
  secret_name      = "argocd-ssh-key" // SHH private key in AWS Secrets Manager
  git_repo_ssh_url = "git@github.com:Relay24/sample-devops-infra.git"

  # cluster_endpoint                   = module.eks.cluster_endpoint
  # cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  # cluster_name                       = module.eks.cluster_name

  kubernetes_host                    = module.eks.cluster_endpoint
  kubernetes_cluster_ca_certificate  = module.eks.cluster_certificate_authority_data
  kubernetes_token                   = data.aws_eks_cluster_auth.this.token

  # depends_on = [module.eks]
}