terraform {
  cloud {
    organization = "BidiiCloud"
    workspaces {
      name = "acm-nginx"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_namespace" "nginx-app" {
  metadata {
    name = "nginx-app"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    namespace = kubernetes_namespace.nginx-app.metadata.0.name
    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
    namespace = kubernetes_namespace.nginx-app.metadata.0.name
    labels = {
      app = "nginx"
    }
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      name = "http"
      port = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}