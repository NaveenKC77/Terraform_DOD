data "aws_vpc" "mtc_vpc" {
  filter {
    name   = "tag:Name"
    values = ["mtc_vpc"]
  }
}

data "aws_security_group" "public_sg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.mtc_vpc.id] # VPC ID
  }
  filter {
    name   = "tag:Name"
    values = ["public_sg"]
  }
}

data "aws_internet_gateway" "example" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.mtc_vpc.id] # Replace with your VPC ID or reference
  }
}

data "aws_key_pair" "mtc_key" {
  key_name = "mtc_key"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240927"]
  }

}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.mtc_vpc.id]
  }

  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.mtc_vpc.id]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

data "aws_db_subnet_group" "public_db_subnet_group"{
  name = "public_db_subnet_group"
  vpc_id = data.aws_vpc.mtc_vpc.ipv6_association_id
}

# public_subnet_ids
#private_subnet_ids
