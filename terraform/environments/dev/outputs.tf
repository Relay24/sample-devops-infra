output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Configure kubectl: run the following command to update your kubeconfig"
  value       = "      aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${local.region}          "
}