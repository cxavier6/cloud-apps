# Create EKS Cluster and Node Group

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
  principal_arn     = "arn:aws:iam::547886934166:user/camila"
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