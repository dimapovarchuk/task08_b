resource "kubectl_manifest" "secret-provider" {
  yaml_body = templatefile("${path.root}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = var.aks_secret_provider_identity_id
    kv_name                    = var.keyvault_name
    tenant_id                  = var.tenant_id
    redis_url_secret_name      = var.redis_hostname_secret
    redis_password_secret_name = var.redis_primary_key_secret
  })
}

resource "kubectl_manifest" "deployment" {
  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
  yaml_body = templatefile("${path.root}/k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = var.acr_login_server
    app_image_name   = var.image_name
    image_tag        = var.image_tag
  })

  depends_on = [
    kubectl_manifest.secret-provider
  ]
}

resource "kubectl_manifest" "service" {
  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }
  yaml_body = file("${path.root}/k8s-manifests/service.yaml")

  depends_on = [
    kubectl_manifest.deployment
  ]
}

data "kubernetes_service" "service" {
  metadata {
    name      = "redis-flask-app-service"
    namespace = "default"
  }
  depends_on = [kubectl_manifest.service]
}
