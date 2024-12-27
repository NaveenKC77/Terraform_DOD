terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
locals {
  environment = terraform.workspace

  profile = {
    "localstack" = "localstack"
    "dev"        = "dev"
    "staging"    = "staging"
    "prod"       = "prod"
  }

  regions = {
    "localstack" = "us-west-2"
    "dev"        = "us-west-2"
    "staging"    = "us-west-2"
    "prod"       = "us-west-2"
  }

  region       = lookup(local.regions, local.environment)
  profile_name = lookup(local.profile, local.environment)
}
# terraform { 
#   cloud { 
    
#     organization = "Nabin779" 

#     workspaces { 
#       name = "dev" 
#     } 
#   } 
# }


provider "aws" {
  region  = local.region
  profile =  local.profile_name

  dynamic "endpoints" {
    for_each = local.environment == "localstack" ? [1] : []

    content {
      apigateway     = "http://localhost:4566"
      cloudformation = "http://localhost:4566"
      cloudwatch     = "http://localhost:4566"
      dynamodb       = "http://localhost:4566"
      es             = "http://localhost:4566"
      firehose       = "http://localhost:4566"
      iam            = "http://localhost:4566"
      kinesis        = "http://localhost:4566"
      lambda         = "http://localhost:4566"
      route53        = "http://localhost:4566"
      redshift       = "http://localhost:4566"
      s3             = "http://localhost:4566"
      secretsmanager = "http://localhost:4566"
      ses            = "http://localhost:4566"
      sns            = "http://localhost:4566"
      sqs            = "http://localhost:4566"
      ssm            = "http://localhost:4566"
      stepfunctions  = "http://localhost:4566"
      sts            = "http://localhost:4566"
    }
  }

  skip_credentials_validation = local.environment == "localstack"
  skip_metadata_api_check     = local.environment == "localstack"
  skip_requesting_account_id  = local.environment == "localstack"
}

