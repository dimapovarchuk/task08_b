#!/bin/bash
source "../../../shared_libs/shell_functions.sh" &>/dev/null
load_vars_from_json_file "../infra/input.json"
load_vars_from_json_file "../infra/output.json"

# Set credentials
az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}" >/dev/null
az account set --subscription "${ARM_SUBSCRIPTION_ID}"

bash ../../../scripts/env2template/main.sh terraform.tfvars.tpl terraform.tfvars

rm -f .terraform.tfstate.lock.info

terraform init

if [ "$1" == "up" ]; then
    # Deploy all infrastructure
    terraform apply -auto-approve -var="deploy_kubernetes_resources=false"
    
    # Wait for AKS cluster to be ready
    echo "Waiting for AKS cluster to be ready..."
    sleep 120
    
    # Get AKS credentials
    echo "Getting AKS credentials..."
    az aks get-credentials --resource-group cmtr-${custom_identifier}-rg --name cmtr-${custom_identifier}-aks --overwrite-existing
    
    # Create namespace if it doesn't exist
    kubectl create namespace default --dry-run=client -o yaml | kubectl apply -f -
    
    # Deploy kubernetes resources
    terraform apply -auto-approve -var="deploy_kubernetes_resources=true"
    
    # Get and display IP
    IP=$(kubectl get service redis-flask-app-service -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [ ! -z "$IP" ]; then
        echo "$IP"
    fi
    
elif [ "$1" == "down" ]; then
    # Destroy all resources
    terraform destroy -auto-approve -var="deploy_kubernetes_resources=false"
else
    echo "Usage: $0 {up|down}"
    exit 1
fi