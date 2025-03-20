resource "helm_release" "redis" {
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
  storageClass: "gp2"  
  size: 8Gi            
EOF
  ]
}