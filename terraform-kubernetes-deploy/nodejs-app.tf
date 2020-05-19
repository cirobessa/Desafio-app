resource "kubernetes_deployment" "contador" {
  metadata {
    name = "scalable-contador-example"
    labels = {
      App = "ContadorEmNodeJs"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ContadorEmNodeJs"
      }
    }
    template {
      metadata {
        labels = {
          App = "ContadorEmNodeJs"
        }
      }
      spec {
        container {
          image = "cirobessa/counter.js"
          name  = "example"

          port {
            container_port = 8082
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
