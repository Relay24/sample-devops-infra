# ----------------------------------------------------------------------
#  Argo CD
# ----------------------------------------------------------------------
# https://artifacthub.io/packages/helm/argo-cd-oci/argo-cd
# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   namespace  = var.argocd_namespace
#   create_namespace = true
#   version    = "7.8.8"
#
#   values = [file("${path.module}/values.yaml")]
# }

# Провайдеры (AWS, Helm, Kubernetes)

# EKS кластер, IAM роли (для ArgoCD)

# Установка ArgoCD (минимальная, с --insecure)
resource "helm_release" "argocd_bootstrap" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "7.8.8"

  set {
    name  = "server.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "server.serviceAccount.name"
    value = "argocd-server"
  }

  # set {
  #   name = "server.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   value = aws_iam_role.argocd_role.arn # Замените на ваш IAM Role ARN
  # }

  values           = [file("${path.module}/values.yaml")]
  create_namespace = true
}

resource "kubernetes_manifest" "argocd_bootstrap_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "argocd-bootstrap"
      namespace = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.git_repo_ssh_url
        targetRevision = "HEAD"
        path           = "bootstrap/*" #  bootstrap-manifest
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }
  depends_on = [helm_release.argocd_bootstrap]
}


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
    name          = "root-argocd-repo"
    url           = var.git_repo_ssh_url
    sshPrivateKey = base64decode(jsondecode(data.aws_secretsmanager_secret_version.argocd_secrets_version.secret_string)["ssh-privatekey"])
  }
  type       = "Opaque"
  depends_on = [helm_release.argocd_bootstrap, data.aws_secretsmanager_secret_version.argocd_secrets_version]
}

resource "kubernetes_manifest" "argocd_bootstrap_appset" {
  manifest = yamldecode(file("${path.module}/bootstrap-app.yaml"))
}

# resource "kubernetes_manifest" "argocd_root_application" {
#   manifest = yamldecode(file("../../../apps-config/bootstrap-app.yaml"))
#   depends_on = [helm_release.argocd]
# }