variable "argocd_namespace" {
  type        = string
  description = "Namespace to deploy ArgoCD into."
  default     = "argocd"
}

# variable "cluster_endpoint" {
#   type        = string
#   description = "The endpoint for the EKS cluster."
# }
#
# variable "cluster_certificate_authority_data" {
#   type        = string
#   description = "Base64 encoded certificate authority data."
# }
#
# variable "cluster_name" {
#   type = string
#   description = "Cluster name"
# }

provider "kubernetes" {
  host                   = var.kubernetes_host
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_certificate)
  token                  = var.kubernetes_token
}

variable "kubernetes_host" {
  type        = string
  description = "Kubernetes API server endpoint"
}

variable "kubernetes_cluster_ca_certificate" {
  type        = string
  description = "Kubernetes cluster CA certificate data"
}

variable "kubernetes_token" {
  type        = string
  description = "Kubernetes authentication token"
  sensitive   = true
}

variable "git_repo_ssh_url" {
  type        = string
  description = "Git repository URL (SSH)."
}

variable "secret_name" {
  type        = string
  description = "Name of the AWS Secrets Manager secret."
}
