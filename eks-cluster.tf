#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "demo-cluster" {
  name = "terraform-eks-demo-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo-cluster.name
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.demo-cluster.name
}

# resource "aws_security_group" "demo-cluster" {
#   name        = "terraform-eks-demo-cluster"
#   description = "Cluster communication with worker nodes"
#   vpc_id      = "vpc-0f0fbba10d5ec06e0"
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "terraform-eks-demo"
#   }
# }

# resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
#   cidr_blocks       = [local.workstation-external-cidr]
#   description       = "Allow workstation to communicate with the cluster API Server"
#   from_port         = 443
#   protocol          = "tcp"
#   security_group_id = aws_security_group.demo-cluster.id
#   to_port           = 443
#   type              = "ingress"
# }

data "aws_subnets" "availability_zone" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_eks_cluster" "demo" {
  name     = var.cluster-name
  role_arn = aws_iam_role.demo-cluster.arn

  vpc_config {
    security_group_ids = ["sg-0b0503ebc0e28010f"]
    subnet_ids = [
      "subnet-00e08a11f9ce86ab0",
      "subnet-00e08a11f9ce86ab0",
      "subnet-08f9822e4c3eea2ba",
      "subnet-07aa07ff9b2456755"
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSVPCResourceController,
  ]
}
