output "aca_fqdn" {
  description = "FQDN of App in Azure Container App"
  value       = module.aca-app.aca_fqdn
}

output "redis_fqdn" {
  description = "FQDN of Redis in ACI"
  value       = module.redis_cache.redis_url
}

output "aks_lb_ip" {
  description = "Load Balancer IP address of APP in AKS"
  value       = try(module.k8s-app-deployment[0].aks_lb_ip, null)
}