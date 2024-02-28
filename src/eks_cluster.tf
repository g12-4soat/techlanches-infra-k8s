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
  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  cluster_name  = var.eksName
  disk_size     = 20

  instance_types = [
    "t3.medium"
  ]

  node_group_name = "techlanches-node"
  node_role_arn   = data.aws_iam_role.name.arn
  release_version = "1.29.0-20240213"
  subnet_ids      = [for subnet in data.aws_subnet.selected : subnet.id if subnet.availability_zone != "us-east-1e"]
  version         = "1.29"

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name                = var.eksName
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.28.0-eksbuild.1"
  resolve_conflicts_on_create = "NONE"
  resolve_conflicts_on_update = "NONE"
}
