terraform {
  backend "s3" {
    bucket = "terra-jekins-26-12"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"

  }
}
