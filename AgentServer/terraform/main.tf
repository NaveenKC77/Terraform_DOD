module "vpc" {
  source = "../../VPC"

  aws_region         = "us-west-2"
  availaibilty_zones = ["us-west-2a", "us-west-2b"]

}

