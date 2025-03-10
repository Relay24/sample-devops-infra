output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_auth_token" {
  value = data.aws_eks_cluster_auth.this.token
  sensitive = true
}

output "configure_kubectl" {
  description = "Configure kubectl: run the following command to update your kubeconfig"
  value       = "      aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${local.region}          "
}