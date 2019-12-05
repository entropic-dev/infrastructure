terraform {
  backend "s3" {
    bucket = "entropic-terraform"
    key    = "entropictf"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

