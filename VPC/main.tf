# VPC 
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mtc_vpc"
  }
}

# Public Subnets ->2 , us-east-1a , us-east-1b
resource "aws_subnet" "mtc_public_subnet" {
  vpc_id            = aws_vpc.mtc_vpc.id
  count             = length(var.availaibilty_zones)
  cidr_block        = cidrsubnet(aws_vpc.mtc_vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(var.availaibilty_zones, count.index)


  tags = {
    Name = "mtc_public_subnet${count.index + 1}"
    Type = "public"
  }
}

# Private Subnets -> 2 , us-east-1a , us-east-1b
resource "aws_subnet" "mtc_private_subnet" {
  vpc_id            = aws_vpc.mtc_vpc.id
  count             = length(var.availaibilty_zones)
  cidr_block        = cidrsubnet(aws_vpc.mtc_vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(var.availaibilty_zones, count.index)

  tags = {
    Name = "mtc_private_subnet${count.index + 1}"
    Type = "private"
  }
}

resource "aws_db_subnet_group" "public_subnet_group" {
  name       = "public_subnet_group"
  subnet_ids = [aws_subnet.mtc_public_subnet[0].id,aws_subnet.mtc_public_subnet[1].id]
 

  tags = {
    Name = "public_db_subnet_group"
  }
}


#Internet Gateway
resource "aws_internet_gateway" "mtc_gw" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_gw"
  }
}

#Public Route Table
resource "aws_route_table" "mtc_public_route_table" {
  vpc_id = aws_vpc.mtc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mtc_gw.id
  }

  tags = {
    Name = "mtc_public_route_table"
  }
}

#Public route table assocs for each public subnets
resource "aws_route_table_association" "mtc_public_route_table_assoc" {
  route_table_id = aws_route_table.mtc_public_route_table.id
  count          = length(var.availaibilty_zones)
  subnet_id      = element(aws_subnet.mtc_public_subnet[*].id, count.index)
}

#eip
resource "aws_eip" "mtc_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.mtc_gw]
}

#Nat Gateway -> only one for first private subnet
resource "aws_nat_gateway" "mtc_nat_gateway" {
  subnet_id     = element(aws_subnet.mtc_public_subnet[*].id, 0)
  allocation_id = aws_eip.mtc_eip.id
  depends_on    = [aws_internet_gateway.mtc_gw]

  tags = {
    Name = "mtc_nat_gateway"
  }
}

#private route table for private subnets
resource "aws_route_table" "mtc_private_route_table" {
  vpc_id = aws_vpc.mtc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mtc_nat_gateway.id
  }
  depends_on = [aws_nat_gateway.mtc_nat_gateway]

  tags = {
    Name = "mtc_private_subnet_route_table"
  }
}

# route table assoc for private subnets
resource "aws_route_table_association" "mtc_private_subnet_route_table_assoc" {
  route_table_id = aws_route_table.mtc_private_route_table.id
  count          = length(var.availaibilty_zones)
  subnet_id      = element(aws_subnet.mtc_private_subnet[*].id, count.index)
}