# fetch existing VPC
data "aws_vpc" "mtc_vpc" {
  filter {
    name   = "tag:Name"
    values = ["mtc_vpc"]
  }
}

# fetching internet Gateway
data "aws_internet_gateway" "mtc_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.mtc_vpc.id] # Replace with your VPC ID or reference
  }
}

# fetching public key 
data "aws_key_pair" "mtc_key" {
  key_name = "mtc_key"
}

# ubuntu 24.04 image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240927"]
  }

}

# Public subnets
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

# Private Subnets
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

# ID of running setup instance
data "aws_instance" "setup_instance" {
  instance_id = "i-0033a5078eddacc73" 
}




