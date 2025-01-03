data "aws_vpc" "mtc_vpc" {
  filter {
    name   = "tag:Name"
    values = ["mtc_vpc"]
  }
}

# Fetch the public subnet 2
data "aws_subnet" "public_subnet_2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.mtc_vpc.id] 
  }

  filter {
    name   = "tag:Name"
    values = ["mtc_public_subnet2"] 
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

