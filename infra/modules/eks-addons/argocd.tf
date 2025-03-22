resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.0.0"

  create_namespace = true  

  values = [<<EOF
  controller:
    replicas: 1
    serviceAccount:
      create: true
      name: argocd-server  
      annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::547886934166:role/argocd-role
        update-timestamp: "${timestamp()}"
  configs:
    params:
        server.insecure: true
  server:
    ingress:
        enabled: false
  dex:
    enabled: false
  repoServer:
    replicas: 2
  redis:
    enabled: true
    replicas: 1
  metrics:
    enabled: true
  EOF
]

}
