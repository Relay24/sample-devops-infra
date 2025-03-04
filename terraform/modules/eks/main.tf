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

  cluster_enabled_log_types = [] # disable cluster logging

  cluster_addons = {
    eks-pod-identity-agent = {
      most_recent    = true
      enable_logging = false
    }
    coredns = {
      most_recent    = true
      enable_logging = false
    }
    kube-proxy = {
      most_recent    = true
      enable_logging = false
    }
    vpc-cni = {
      most_recent    = true
      enable_logging = false
    }
  }

  eks_managed_node_group_defaults = {
    # instance_types = [var.instance_type]
    # disk_size = 16
  }

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

# https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.20.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # https://github.com/hashicorp/terraform-aws-hashicorp-vault-eks-addon/blob/main/blueprints/getting-started/v5/main.tf
  enable_argocd = true

  argocd = {
    name          = "argocd"
    chart_version = "7.8.7"
    repository    = "https://argoproj.github.io/argo-helm"
    namespace     = "argocd"
    # values        = [templatefile("${path.module}/values.yaml", {})]
  }

  # enable_metrics_server = true
  # metrics_server = {
  #   chart_version = "3.12.1" # https://artifacthub.io/packages/helm/metrics-server/metrics-server
  # }

  # enable_cluster_autoscaler = true
  # cluster_autoscaler = {
  #   chart_version = "9.37.0" # https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
  # }

  #   enable_external_dns = true # https://kubernetes-sigs.github.io/external-dns/latest/
  #   external_dns_route53_zone_arns = ["arn:aws:route53:::hostedzone/*"]
  #   external_dns = {
  #     chart_version = "1.15.0" # https://artifacthub.io/packages/helm/external-dns/external-dns
  #     values        = [file("${path.module}/values/external-dns-values.yaml")]
  #   }

  # enable_aws_load_balancer_controller = true
  # aws_load_balancer_controller = {
  #   chart_version = "1.8.2" # https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
  #   set = [{
  #     name  = "enableServiceMutatorWebhook"
  #     value = "false" # Turn off mutation webhook for services to avoid ordering issue
  #   }]
  # }

  # enable_ingress_nginx = true
  # ingress_nginx = {
  #   chart_version = "4.11.2" # https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx/
  #   values        = [file("${path.module}/values/nginx-ingress.yaml")]
  # }

  # enable_cert_manager = true
  # cert_manager = {
  #   chart_version = "1.15.3" # https://artifacthub.io/packages/helm/cert-manager/cert-manager
  #   wait          = true     # Wait for all Cert-manager related resources to be ready
  # }

  #   enable_kube_prometheus_stack = true
  #   kube_prometheus_stack = {
  #     chart_version = "62.7.0" # https://artifacthub.io/packages/helm/kube-prometheus-stack-oci/kube-prometheus-stack/
  #     values        = [file("${path.module}/values/prometheus-values.yaml")]
  #   }
  #
  #   eks_addons = {
  #     aws-ebs-csi-driver = {
  #       most_recent              = true
  #       enable_logging           = false
  #       service_account_role_arn = module.ebs_csi_driver_irsa_role.iam_role_arn
  #     }
  #   }

  # tags = var.tags
  depends_on = [module.eks]
}