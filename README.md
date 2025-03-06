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

# Manual Steps for Deploying a Kubernetes Cluster on AWS

## Prerequisites
Before deploying the cluster, ensure you have the following:
- Access to the AWS CLI
- An AWS IAM user with the necessary permissions to create resources
- A configured AWS profile
- A generated SSH key pair for secure access

## Step 1: Configure AWS CLI
If you haven't configured the AWS CLI yet, run:
```sh
aws configure
```
Enter your AWS credentials when prompted.

## Step 2: Generate an SSH Key (if not already available)
To generate an SSH key pair, use:
```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/argocd_deploy_key -N ""
```
This will create a private key (`argocd_deploy_key`) and a public key (`argocd_deploy_key.pub`).

## Step 3: Store the SSH Key in AWS Secrets Manager
Encrypt and store the SSH private key securely:
```sh
aws secretsmanager create-secret \
  --name argocd-ssh-key \
  --description "ArgoCD SSH private key" \
  --secret-string "{\"ssh-privatekey\":\"$(base64 -w 0 ~/.ssh/argocd_deploy_key)\"}" \
  --kms-key-id alias/aws/secretsmanager \
  --region us-east-1
```
This ensures the key is encrypted and accessible securely.

## Step 4: Deploy the Kubernetes Cluster
Use Terraform or another IaC tool to deploy your cluster. Ensure your Terraform configuration includes:
- VPC setup
- EKS cluster configuration
- Worker nodes configuration

Apply the Terraform configuration:
```sh
terraform init
terraform apply -auto-approve
```

## Step 5: Verify the Cluster Deployment
Once Terraform completes, configure `kubectl` to connect to the cluster:
```sh
aws eks update-kubeconfig --region us-east-1 --name <cluster-name>
```
Verify the cluster is running:
```sh
kubectl get nodes
```

Now your Kubernetes cluster is deployed and ready for use!

