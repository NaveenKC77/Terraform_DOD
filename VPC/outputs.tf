output "vpc_id" {
  value = aws_vpc.mtc_vpc.id
}

output "public_subnet_group_name"{
    value = aws_db_subnet_group.public_subnet_group.name
}

output "public_subnet_1_id"{
  value = aws_subnet.mtc_public_subnet[0].id
}