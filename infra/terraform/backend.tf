# Uncomment if you want to store Terraform state in S3
# terraform {
#   backend "s3" {
#     bucket         = "<tfstate-bucket>"
#     key            = "eks-starter/terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "<lock-table>"
#     encrypt        = true
#   }
# }
