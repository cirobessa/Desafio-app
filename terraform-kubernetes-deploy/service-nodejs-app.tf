resource "kubernetes_service" "contador" {
  metadata {
    name = "contador-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.contador.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 8082
      target_port = 8082
    }

    type = "NodePort"
  }
}
