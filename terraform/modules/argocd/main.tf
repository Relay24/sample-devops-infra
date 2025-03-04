# # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
# module "argocd_iam_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.0" # Актуальная версия
#
#   role_name = "argocd-role-${module.eks.cluster_name}"
#   # !!!!!!!!
#   attach_policy_arns = [
#     "arn:aws:iam::aws:policy/AdministratorAccess", # !!! ЗАМЕНИТЕ НА НУЖНЫЕ ПОЛИТИКИ !!!
#   ]
#
#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["argocd:argocd-server"] # !!! namespace:service_account
#     }
#   }
#   tags = var.tags
# }
#
# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   namespace  = "argocd"
#   create_namespace = true
#   version    = var.argocd_version
#
#   set {
#     name  = "server.serviceAccount.create"
#     value = "true"
#   }
#   set {
#     name = "server.serviceAccount.name"
#     value = "argocd-server"
#   }
#   set {
#     name = "server.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.argocd_iam_role.iam_role_arn
#   }
#   set {
#     name = "configs.secret.createSecret"
#     value = "false"
#   }
#
#   values = [
#     <<-EOT
#     configs:
#       params:
#         server.insecure: "true"
#     EOT
#   ]
#   depends_on = [kubernetes_namespace.argocd]
# }
# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = "argocd"
#   }
# }
#
# # Применение начальной конфигурации ArgoCD
# resource "null_resource" "apply_argocd_config" {
#   depends_on = [helm_release.argocd]
#
#   provisioner "local-exec" {
#     command = "kubectl apply -f ${var.argocd_config_path} -n argocd"
#     # Добавляем таймаут, на случай если ArgoCD еще не готов
#     interpreter = ["bash", "-c"]
#     command     = <<EOF
#       until kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[*].status.phase}' | grep -q "Running"; do
#         echo "Waiting for ArgoCD server to be ready..."
#         sleep 5
#       done
#       kubectl apply -f ${var.argocd_config_path} -n argocd
#     EOF
#   }
# }