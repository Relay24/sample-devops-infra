# ----------------------------------------------------------------------
# Retrieve secret from AWS Secrets Manager
# ----------------------------------------------------------------------
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "argocd_secrets" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "argocd_secrets_version" {
  secret_id = data.aws_secretsmanager_secret.argocd_secrets.id
}

# ----------------------------------------------------------------------
#  Argo CD
# ----------------------------------------------------------------------
# https://artifacthub.io/packages/helm/argo-cd-oci/argo-cd
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = var.argocd_namespace
  create_namespace = true
  version    = "7.8.8"

  set {
    name  = "server.extraArgs[0]"  # Добавляем --insecure
    value = "--insecure"            # (Удалите для продакшена!)
  }

}

# ----------------------------------------------------------------------
# Create a Kubernetes Secret with a private key
# ----------------------------------------------------------------------
resource "kubernetes_secret" "argocd_repo_ssh_key" {
  metadata {
    name      = "argocd-repo-ssh-key"
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    type          = "git"
    name          = "my-argocd-repo"
    url           = var.git_repo_ssh_url
    sshPrivateKey = base64decode(jsondecode(data.aws_secretsmanager_secret_version.argocd_secrets_version.secret_string)["ssh-privatekey"])
  }
  type = "Opaque"
  depends_on = [helm_release.argocd, data.aws_secretsmanager_secret_version.argocd_secrets_version]
}