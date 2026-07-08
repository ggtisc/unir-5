# Application Security Groups

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ports
    content {
      description      = "Allow ALB HTTP/HTTPS traffic from anywhere"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    description      = "Allow all outbound traffic from ALB"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for application EC2 instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.app_ports
    content {
      description      = "Allow application traffic from the ALB security group"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      security_groups  = [aws_security_group.alb_sg.id]
    }
  }

  egress {
    description      = "Allow all outbound traffic from EC2 instances"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
