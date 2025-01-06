# Security group for Load Balancer 
resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_sg"
  description = "Allow TCP inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.mtc_vpc.id


  ingress {
    description = "For HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "For HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "load_balancer_sg"
  }
}

# Security group from Load Balancer to EC2 instances 
resource "aws_security_group" "as_server_sg" {
  name        = "as-server_sg"
  description = "Allow inbound traffic from load balancer only"
  vpc_id      = data.aws_vpc.mtc_vpc.id


  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "as_server_sg"
  }
}

# Application Load Balancer

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = data.aws_subnets.public_subnets.ids
  depends_on         = [data.aws_internet_gateway.mtc_igw]

  tags = {
    Name = "app_lb"
  }
}

#Target Group For Load Balancer
resource "aws_lb_target_group" "app_lb_target_group" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.mtc_vpc.id
  tags = {
    Name = "app_lb_target_group"
  }
}

#Listener for Load Balancer 
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
  tags = {
    Name = "app_lb_listener"
  }
}
# Create an AMI from the specified instance
resource "aws_ami_from_instance" "setup" {
  name               = "my-custom-ami"
  source_instance_id = data.aws_instance.setup_instance.id
  description        = "An AMI created from an existing EC2 instance"

}

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "app_launch_template" {
  name          = "app_launch_template"
  image_id      = aws_ami_from_instance.setup.id
  instance_type = "t2.micro"
  

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.as_server_sg.id]
  }


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app_lb_instance"
    }
  }


}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_auto_scaling_group" {
  name                = "app_auto_scaling_group"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  health_check_type   = "EC2"
  vpc_zone_identifier = data.aws_subnets.private_subnets.ids
  target_group_arns   = [aws_lb_target_group.app_lb_target_group.arn]

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
  # lifecycle {
  #   create_before_destroy = true 
  # }
}
