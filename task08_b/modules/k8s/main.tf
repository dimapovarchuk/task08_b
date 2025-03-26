resource "kubectl_manifest" "secret-provider" {
  yaml_body = templatefile("${path.root}/k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = var.aks_secret_provider_identity_id
    kv_name                    = var.keyvault_name
    tenant_id                  = var.tenant_id
    redis_url_secret_name      = var.redis_hostname_secret
    redis_password_secret_name = var.redis_primary_key_secret
  })

  wait = true
  timeouts {
    create = "2m"
  }
}

resource "time_sleep" "wait_after_secret_provider" {
  depends_on      = [kubectl_manifest.secret-provider]
  create_duration = "30s"
}

resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.root}/k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = var.acr_login_server
    app_image_name   = var.image_name
    image_tag        = var.image_tag
  })

  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }

  depends_on = [
    kubectl_manifest.secret-provider,
    time_sleep.wait_after_secret_provider
  ]
}

resource "time_sleep" "wait_after_deployment" {
  depends_on      = [kubectl_manifest.deployment]
  create_duration = "30s"
}

resource "kubectl_manifest" "service" {
  yaml_body = file("${path.root}/k8s-manifests/service.yaml")

  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }

  depends_on = [
    kubectl_manifest.deployment,
    time_sleep.wait_after_deployment
  ]
}

resource "time_sleep" "wait_for_service" {
  depends_on      = [kubectl_manifest.service]
  create_duration = "60s"
}

data "kubernetes_service" "service" {
  metadata {
    name      = "redis-flask-app-service"
    namespace = "default"
  }

  depends_on = [
    kubectl_manifest.service,
    time_sleep.wait_for_service
  ]
}