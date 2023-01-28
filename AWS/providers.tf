terraform {
  cloud {
    organization = "BidiiCloud"

    workspaces {
      name = "acm-aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
