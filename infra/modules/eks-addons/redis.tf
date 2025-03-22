resource "helm_release" "redis" {
  depends_on = [ kubernetes_storage_class_v1.ebs ]

  name       = "redis"
  namespace  = "redis"
  chart      = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "18.1.2"

  create_namespace = true

  values = [<<EOF
auth:
  enabled: false
architecture: standalone
persistence:
  enabled: true          
EOF
  ]
}