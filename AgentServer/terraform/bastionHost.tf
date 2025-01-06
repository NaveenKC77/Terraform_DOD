# Security Group for Public Instance
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "public_sg"
  }
}
# Public Instance
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnet_1_id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.public_sg.id]
  key_name                    = aws_key_pair.mtc_key.key_name

  tags = {
    Name = "bastion-host"
  }
}

