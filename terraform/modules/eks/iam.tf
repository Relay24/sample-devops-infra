# module "argocd_iam_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.0" # Актуальная версия
#
#   role_name = "argocd-role-${module.eks.cluster_name}"
#   attach_policy_arns = [
#     "arn:aws:iam::aws:policy/AdministratorAccess",
#   ]
#
#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["argocd:argocd-server"]
#     }
#   }
#   tags = var.tags
# }