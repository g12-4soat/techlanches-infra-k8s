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

