# Security Group for setupServer
resource "aws_security_group" "agent_server_sg" {
  name        = "agent_server_sg"
  description = "Allow SSH from my github"
  vpc_id      = module.vpc.vpc_id

ingress {
    description = "For SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "For HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "agent_server_sg"
  }
}


# key pair for instances
resource "aws_key_pair" "agent_server_key" {
  key_name   = "agent_server_key"
  public_key = file("~/.ssh/setupServerKey.pub")
}

# Setup Subnet

resource "aws_iam_role" "agent_server_role" {
  name = "s3FullAccessToEC2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "agent_server_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.agent_server_role.name
}

resource "aws_iam_instance_profile" "agent_server_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.agent_server_role.name
}

resource "aws_instance" "agent_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.agent_server_key.id
  vpc_security_group_ids      = [aws_security_group.agent_server_sg.id]
  subnet_id                   = module.vpc.public_subnet_1_id
  iam_instance_profile        = aws_iam_instance_profile.agent_server_instance_profile.name
  user_data                   = filebase64("../userdata.sh")


  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "setup_instance"
  }
}