variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "demo-eks"
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
  default     = "myapp"
}

variable "desired_size" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "EC2 instance types for node group"
  type        = list(string)
  default     = ["t3.medium"]
}
