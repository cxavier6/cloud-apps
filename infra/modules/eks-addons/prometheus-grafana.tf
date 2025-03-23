resource "helm_release" "prometheus_grafana" {
  name              = "prometheus-grafana"
  namespace         = "monitoring"
  chart             = "kube-prometheus-stack"
  repository        = "https://prometheus-community.github.io/helm-charts"
  version           = "70.0.0"
  
  create_namespace  = true

  values = [<<EOF
prometheus:
  enabled: true
  prometheusSpec:
    storageSpec: {}

grafana:
  enabled: true
  service:
    type: ClusterIP
EOF
  ]
}