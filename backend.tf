terraform {
  backend "s3" {
    bucket = "terraformstate696"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}