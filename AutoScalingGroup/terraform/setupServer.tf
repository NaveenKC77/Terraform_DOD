
# # Security Group for setupServer
# resource "aws_security_group" "setup_server_sg" {
#   name        = "setup_server_sg"
#   description = "Allow SSH from my ip"
#   vpc_id      = module.vpc.vpc_id


#   ingress {
#     description = "For SSH"
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "setup_server_sg"
#   }
# }

# # key pair for instances
# resource "aws_key_pair" "setupServerKey" {
#   key_name   = "setupServerKey"
#   public_key = file("~/.ssh/setupServerKey.pub")
# }

# # Setup Subnet

# resource "aws_iam_role" "ec2_role" {
#   name = "s3FullAccessToEC2"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = aws_iam_role.ec2_role.name
# }

# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "ec2_instance_profile"
#   role = aws_iam_role.ec2_role.name
# }

# resource "aws_instance" "setup_instance" {
#   ami                         = data.aws_ami.linux.id
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.setupServerKey.id
#   vpc_security_group_ids      = [aws_security_group.setup_server_sg.id]
#   subnet_id                   = module.vpc.public_subnet_1_id
#   iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
#   user_data                   = filebase64("../../userdataTest.sh")


#   root_block_device {
#     volume_size = 8
#   }

#   tags = {
#     Name = "setup_instance"
#   }
# }
# # Creating custom AMI from my setupServer
# resource "aws_ami_from_instance" "my_custom_ami" {
#   name                = "my-custom-ami-${aws_instance.setup_instance.id}"
#   description         = "Custom AMI from my setup_instance"
#   source_instance_id  = aws_instance.setup_instance.id


#   tags = {
#     Name = "Setup Server AMI"
#   }
# }