output "redis_fqdn" {
  description = "FQDN of Redis in ACI"
  value       = module.redis_cache.redis_url
}

output "aca_fqdn" {
  description = "FQDN of App in Azure Container App"
  value       = module.aca-app.aca_fqdn
}

output "aks_lb_ip" {
  description = "Load Balancer IP address of APP in AKS"
  value       = module.k8s-app-deployment.aks_lb_ip
}
