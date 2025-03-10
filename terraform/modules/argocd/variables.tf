variable "secret_name" {
  type        = string
  description = "Name of the AWS Secrets Manager secret containing ArgoCD credentials."
}

variable "git_repo_ssh_url" {
  type        = string
  description = "SSH URL of the Git repository."
}

variable "argocd_namespace" {
  type        = string
  description = "Namespace to deploy ArgoCD into."
  default     = "argocd"
}