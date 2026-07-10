# ALB module resources

# Application Load Balancer
# Public-facing load balancer for distributing traffic to backend EC2 instances
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  access_logs {
    bucket  = var.access_logs_bucket_id
    prefix  = "alb-logs"
    enabled = true
  }

  tags = {
    Name = "alb-iaas-1"
  }
}

# Target Group for the ALB
# Defines how traffic is routed to backend instances (port 80 - Nginx)
resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "tg-iaas-1"
  }
}

# ALB Listener
# Listens on port 80 and forwards traffic to the target group
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
