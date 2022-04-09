variable "aws_region" {
  default = "us-east-1"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "vpc_id" {
  default = "vpc-0f0fbba10d5ec06e0"
}

variable "instance_types" {
  default = ["t2.micro"]
  type    = set(any)
}
