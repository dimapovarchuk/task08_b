output "aks_lb_ip" {
  description = "IP address of the App Load Balancer"
  value       = data.kubernetes_service.service.status[0].load_balancer[0].ingress[0].ip
}