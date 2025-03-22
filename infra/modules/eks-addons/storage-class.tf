# Create a default storage class for EKS cluster with EBS CSI driver
resource "kubernetes_storage_class_v1" "ebs" {
    metadata {
        name = "ebs"
        annotations = {
            "storageclass.kubernetes.io/is-default-class" = "true"
        }
    }

    storage_provisioner = "ebs.csi.aws.com"

    parameters = {
        type = "gp2"
    }

    reclaim_policy       = "Retain"
    volume_binding_mode  = "WaitForFirstConsumer"
}
