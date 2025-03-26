provider "azurerm" {
  features {}
}

provider "kubectl" {
  host                   = var.deploy_kubernetes_resources ? module.aks.kube_config_host : ""
  client_certificate     = var.deploy_kubernetes_resources ? base64decode(module.aks.kube_config_client_certificate) : ""
  client_key             = var.deploy_kubernetes_resources ? base64decode(module.aks.kube_config_client_key) : ""
  cluster_ca_certificate = var.deploy_kubernetes_resources ? base64decode(module.aks.kube_config_cluster_ca_certificate) : ""
  load_config_file       = false
}

provider "kubernetes" {
  host                   = var.deploy_kubernetes_resources ? module.aks.kube_config_host : ""
  client_certificate     = var.deploy_kubernetes_resources ? base64decode(module.aks.kube_config_client_certificate) : ""
  client_key             = var.deploy_kubernetes_resources ? base64decode(module.aks.kube_config_client_key) : ""
  cluster_ca_certificate = var.deploy_kubernetes_resources ? base64decode(module.aks.kube_config_cluster_ca_certificate) : ""
}