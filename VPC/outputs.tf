output "vpc_id" {
  value = aws_vpc.mtc_vpc.id
}
output "igw"{
  value = aws_internet_gateway.mtc_gw
}

output "public_subnet_group_name"{
    value = aws_db_subnet_group.public_subnet_group.name
}
output "private_subnet_ids"{
  value = aws_subnet.mtc_private_subnet[*].id
}
output "public_subnet_ids"{
  value = aws_subnet.mtc_public_subnet[*].id
}

output "public_subnet_1_id"{
  value = aws_subnet.mtc_public_subnet[0].id
}