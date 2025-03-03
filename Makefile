# Makefile for EKS Cluster with ArgoCD (Minimal, Single Repository)

# --- Variables (Customize these!) ---
REGION ?= us-east-1       # AWS Region
CLUSTER_NAME ?= my-eks-cluster # EKS Cluster Name
REPO_URL ?= git@github.com:your-org/your-repo.git  # Your Git repo (SSH URL)
# ------------------------------------

.PHONY: all init plan apply destroy kubeconfig argocd-access argocd-bootstrap argocd-ui argocd-password help

all: init plan apply

init:
	@echo "Initializing Terraform..."
	@terraform -chdir=environments/dev init

plan:
	@echo "Planning Terraform changes..."
	@terraform -chdir=environments/dev plan -out=tfplan

apply:
	@echo "Applying Terraform changes..."
	@terraform -chdir=environments/dev apply "tfplan"

kubeconfig:
	@echo "Configuring kubectl..."
	@aws eks --region $(REGION) update-kubeconfig --name $(CLUSTER_NAME)

argocd-access:
	@echo "Generating SSH key for ArgoCD (if needed)..."
	@if [ ! -f ./argocd-access ]; then \
		ssh-keygen -t ed25519 -C "argocd-access" -f ./argocd-access -N ""; \
		kubectl create secret generic argocd-repo-ssh-key \
		  --namespace argocd \
		  --from-file=sshPrivateKey=./argocd-access; \
	else \
		echo "SSH key already exists.  Skipping..."; \
	fi
	@echo "Add the contents of argocd-access.pub as a deploy key to your Git repository."

argocd-bootstrap:
	@echo "Bootstrapping ArgoCD..."
	@kubectl apply -f argocd/bootstrap-app.yaml -n argocd

argocd-ui:
	@echo "Forwarding ArgoCD UI to localhost:8080..."
	@kubectl port-forward svc/argocd-server -n argocd 8080:443

argocd-password:
	@echo "Retrieving ArgoCD initial admin password..."
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

destroy:
	@echo "Destroying infrastructure..."
	@terraform -chdir=environments/dev destroy

help:
	@echo "Available targets:"
	@echo "  all            - Initialize, plan, and apply Terraform configuration."
	@echo "  init           - Initialize Terraform."
	@echo "  plan           - Create a Terraform execution plan."
	@echo "  apply          - Apply the Terraform configuration."
	@echo "  destroy        - Destroy the Terraform-managed infrastructure."
	@echo "  kubeconfig     - Configure kubectl to connect to the EKS cluster."
	@echo "  argocd-access  - Generate SSH key for ArgoCD (if needed) and create Kubernetes secret."
	@echo "  argocd-bootstrap - Apply the bootstrap-app.yaml to configure ArgoCD."
	@echo "  argocd-ui      - Forward the ArgoCD UI to localhost:8080."
	@echo "  argocd-password - Retrieve the initial ArgoCD admin password."
	@echo "  help           - Display this help message."