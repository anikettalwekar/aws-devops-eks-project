data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name            = "${var.cluster_name}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Project = var.cluster_name
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2_x86_64"
      instance_types = var.instance_types
      desired_size   = var.desired_size
      min_size       = 1
      max_size       = 4
    }
  }

  enable_irsa = true
  tags = {
    Project = var.cluster_name
  }
}

resource "aws_ecr_repository" "this" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
  tags = { Project = var.cluster_name }
}

output "ecr_repo_url"        { value = aws_ecr_repository.this.repository_url }
output "cluster_name"        { value = module.eks.cluster_name }
output "cluster_endpoint"    { value = module.eks.cluster_endpoint }
output "cluster_oidc_issuer" { value = module.eks.cluster_oidc_issuer_url }
