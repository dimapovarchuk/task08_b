# Створюємо namespace
resource "kubernetes_namespace" "default" {
  metadata {
    name = "default"
  }
}

# Створюємо SecretProviderClass
resource "kubectl_manifest" "secret-provider" {
  yaml_body = templatefile("${path.root}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = var.aks_secret_provider_identity_id
    kv_name                    = var.keyvault_name
    tenant_id                  = var.tenant_id
    redis_url_secret_name      = var.redis_hostname_secret
    redis_password_secret_name = var.redis_primary_key_secret
  })

  depends_on = [kubernetes_namespace.default]
}

# Чекаємо після створення SecretProviderClass
resource "time_sleep" "wait_after_secret_provider" {
  depends_on      = [kubectl_manifest.secret-provider]
  create_duration = "30s"
}

# Створюємо Deployment
resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.root}/k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = var.acr_login_server
    app_image_name   = var.image_name
    image_tag        = var.image_tag
  })

  depends_on = [
    kubectl_manifest.secret-provider,
    time_sleep.wait_after_secret_provider
  ]
}

# Чекаємо поки поди запустяться
resource "null_resource" "wait_for_pods" {
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=ready pod -l app=redis-flask-app -n default --timeout=300s"
  }

  depends_on = [kubectl_manifest.deployment]
}

# Створюємо Service
resource "kubectl_manifest" "service" {
  yaml_body = file("${path.root}/k8s-manifests/service.yaml")

  depends_on = [
    kubectl_manifest.deployment,
    null_resource.wait_for_pods
  ]
}

# Чекаємо поки сервіс отримає IP
resource "time_sleep" "wait_for_service" {
  depends_on      = [kubectl_manifest.service]
  create_duration = "60s"
}

# Перевіряємо наявність всіх компонентів
resource "null_resource" "verify_deployment" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl get secretproviderclass redis-flask-app-kv-integration -n default
      kubectl get deployment redis-flask-app -n default
      kubectl get service redis-flask-app-service -n default
      kubectl get pods -l app=redis-flask-app -n default
    EOT
  }

  depends_on = [
    kubectl_manifest.secret-provider,
    kubectl_manifest.deployment,
    kubectl_manifest.service,
    time_sleep.wait_for_service
  ]
}

# Отримуємо IP сервісу
data "kubernetes_service" "service" {
  metadata {
    name      = "redis-flask-app-service"
    namespace = "default"
  }

  depends_on = [
    kubectl_manifest.service,
    time_sleep.wait_for_service,
    null_resource.verify_deployment
  ]
}