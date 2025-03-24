# Creates EKS Cluster and Node Group with AWS addons

resource "aws_eks_cluster" "this" {
  name = var.eks_cluster.cluster_name

  access_config {
    authentication_mode = var.eks_cluster.access_config_authentication_mode
  }

  role_arn = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = var.eks_cluster.enabled_cluster_log_types
  version  = "1.31"

  vpc_config {
    subnet_ids = var.subnet_ids
  }

    tags = merge(
        var.tags,
        {
            Name = var.eks_cluster.cluster_name
        }
    )
  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_eks_access_entry" "this" {
  cluster_name      = aws_eks_cluster.this.name
  principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/camila"
  type              = "STANDARD"
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.eks_cluster.node_group.name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.subnet_ids
  ami_type        = var.eks_cluster.node_group.ami_type
  instance_types  = var.eks_cluster.node_group.instance_types
  capacity_type   = var.eks_cluster.node_group.capacity_type

  scaling_config {
    desired_size = var.eks_cluster.node_group.scaling_config.desired_size
    max_size     = var.eks_cluster.node_group.scaling_config.max_size
    min_size     = var.eks_cluster.node_group.scaling_config.min_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    var.tags,
    {
      Name = var.eks_cluster.node_group.name
    }
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Add-on: VPC CNI (Networking)
resource "aws_eks_addon" "cni" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "vpc-cni"
  addon_version     = "v1.19.2-eksbuild.5" 
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn = aws_iam_role.vpc_cni_role.arn

  depends_on = [aws_eks_cluster.this, aws_eks_node_group.this, aws_iam_openid_connect_provider.eks_oidc] 
}

# Add-on: CoreDNS (Service Discovery)
resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "coredns"
  addon_version     = "v1.11.4-eksbuild.2"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_cluster.this, aws_eks_node_group.this]
}

# Add-on: Kube-Proxy (Network Communication)
resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "kube-proxy"
  addon_version     = "v1.31.3-eksbuild.2" 
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_cluster.this, aws_eks_node_group.this]
}

# Add-on: EBS CSI Driver (Storage)
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.this.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.40.1-eksbuild.1" 
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn = aws_iam_role.ebs_csi_role.arn

  depends_on = [aws_eks_cluster.this, aws_eks_node_group.this, aws_iam_role.ebs_csi_role]
}
