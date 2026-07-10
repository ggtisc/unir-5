resource "aws_launch_template" "app_lt" {
  name = "lt-iaas-1"

  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    security_groups = [var.ec2_sg_id]
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "lt-iaas-1"
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name = "asg-iaas-1"

  vpc_zone_identifier = var.private_subnet_ids
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-iaas-1"
    propagate_at_launch = true
  }
}
