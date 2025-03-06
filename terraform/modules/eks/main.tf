# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.33.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_private_access          = var.cluster_endpoint_private_access
  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true
  create_iam_role = true

  cluster_enabled_log_types = [] # disable cluster logging

  cluster_addons = {
    eks-pod-identity-agent = {
      enable_logging = false
    }
    coredns = {
      enable_logging = false
    }
    kube-proxy = {
      enable_logging = false
    }
    vpc-cni = {
      enable_logging = false
    }
  }

  # eks_managed_node_group_defaults = {
  #   instance_types = [var.instance_type]
  #   disk_size = 16
  # }

  eks_managed_node_groups = {
    general = {
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
      labels       = { role = "general" }

      instance_types = ["c6a.large"]
      #       ["c6a.large"] # 26 pods max cost $0.0261 per hour
      #       ["c6a.large", "c7a.medium"]
      #       ["t3.small"] # 8 pods max cost $0.0066 per hour

      #       capacity_type  = "ON_DEMAND"
      capacity_type = "SPOT"
    }
  }

  # spot = {
  #   desired_size = 1
  #   min_size     = 1
  #   max_size     = 5
  #   labels = {
  #     role = "spot"
  #   }
  #   taints = [{
  #     key    = "market"
  #     value  = "spot"
  #     effect = "NO_SCHEDULE"
  #   }]
  #   instance_types = ["t2.micro"] # cost $0.0037 per hour
  #   capacity_type  = "SPOT"
  # }

  tags = var.tags
}