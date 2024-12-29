resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow TCP inbound traffic from auto scaling security group"
  vpc_id      = module.vpc.vpc_id

  #  For auto scaling servers use
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.setup_server_sg.id]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {
    Name = "db_sg"
  }
}


#db Instance
resource "aws_db_instance" "mtc_rds" {
  identifier             = terraform.workspace
  allocated_storage      = 20
  db_name                = "db_dod"
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "admin12377"
  publicly_accessible    = true
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = module.vpc.public_subnet_group_name
  vpc_security_group_ids = [aws_security_group.db_sg.id]


}
