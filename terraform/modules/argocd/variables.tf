# variable "argo_cd_values" {
#   type = any
#   default = {
#     configs = {
#       params = {
#         "server.insecure" : true
#       }
#     }
#   }
#   description = "Argo CD Helm chart values"
# }
# variable "eso_version" {
#   type        = string
#   description = "Version of the External Secrets Operator Helm chart"
#   default     = "0.9.11"  # Актуальная версия, стоит перепроверять
# }
#
# variable "oidc_provider_arn" {
#   type = string
#   description = "ARN of the EKS OIDC provider"
# }
#
# variable "region" {
#   type = string
#   description = "Регион"
# }
#
# variable "account_id" {
#   type = string
#   description = "ID AWS аккаунта"
# }
#
# variable "argocd_admin_password_secret_name" {
#   type = string
#   description = "The name of the AWS Secrets Manager secret containing the ArgoCD admin password"
#   #  default     = "argocd-admin-password" # Можно задать default
# }
# variable "tags" {
#   type = map(string)
#   default = {}
#   description = "A map of tags to add to all resources"
# }