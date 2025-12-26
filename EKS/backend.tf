terraform {
  backend "s3" {
    bucket = "cicd-eks-26-12"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"

  }
}
