terraform {
  backend "s3" {
    bucket = "aws-spa-tf-state"
    key    = "terraform"
    region = "eu-west-1"
  }
}