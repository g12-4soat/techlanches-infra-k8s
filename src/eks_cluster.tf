resource "aws_eks_cluster" "eks-techlanches" {
  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = var.serviceIpv4
  }

  name     = var.eksName
  role_arn = data.aws_iam_role.name.arn
  version  = var.eksVersion

  vpc_config {
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = [for subnet in data.aws_subnet.selected : subnet.id if subnet.availability_zone != "us-east-1e"]
  }
}

resource "aws_eks_node_group" "techlanches-node" {
  ami_type      = var.nodeAmiType
  capacity_type = var.nodeCapacityType
  cluster_name  = var.eksName
  disk_size     = var.nodeDiskSize

  instance_types = [
    var.nodeInstanceType
  ]

  node_group_name = var.nodeGroupName
  node_role_arn   = data.aws_iam_role.name.arn
  subnet_ids      = [for subnet in data.aws_subnet.selected : subnet.id if subnet.availability_zone != "us-east-1e"]
  version         = var.eksVersion

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  depends_on = [aws_eks_cluster.eks-techlanches]
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name                = var.eksName
  addon_name                  = var.ebsAddonName
  addon_version               = var.ebsAddonVersion
  resolve_conflicts_on_create = "NONE"
  resolve_conflicts_on_update = "NONE"

  depends_on = [aws_eks_cluster.eks-techlanches]
}




