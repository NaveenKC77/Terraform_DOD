# AWS Region
variable "aws_region"{
    type = string
    description = "AWS region for VPC to be deployed in"
    default = "us-west-2"
}

//2 Availaibilty Zones to be used for the project
variable "availaibilty_zones" {
  type        = list(string)
  description = "Availaibilty Zones"
  default     = ["us-east-2a", "us-east-2b"]
}
