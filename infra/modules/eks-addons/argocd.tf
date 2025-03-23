resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.13"

  create_namespace = true  

  values = [<<EOF
  controller:
    replicas: 1

  configs:
    params:
        server.insecure: true
  server:
    ingress:
        enabled: false
    serviceAccount:
      create: true
      name: argocd-server  
      annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/argocd-role
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
