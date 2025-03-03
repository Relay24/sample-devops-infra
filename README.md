# Terraform + EKS + ArgoCD + Vault + Helm/Kustomize/YAML Project

This repository contains the infrastructure and application configuration for deploying a Kubernetes (EKS) cluster with ArgoCD, Vault, and supporting tools, following Infrastructure as Code (IaC) and GitOps principles.

**Key Technologies:**

*   **Terraform:** Infrastructure as Code (IaC) for provisioning the EKS cluster, VPC, and related resources.
*   **Amazon EKS (Elastic Kubernetes Service):** Managed Kubernetes service.
*   **ArgoCD:** GitOps continuous delivery tool for Kubernetes.
*   **HashiCorp Vault:** Securely stores and manages secrets.
*   **Helm:** Package manager for Kubernetes (used for deploying Vault and other applications).
*   **AWS KMS:** For Vault auto-unseal.
* **Prometheus & Grafana:** Monitoring and visualization
* **EFK Stack:** Centralized logging
* **Cert-Manager**: Automatic TLS
* **ExternalDNS**: Automatic management DNS Records
* **Ingress Controller (Nginx)**