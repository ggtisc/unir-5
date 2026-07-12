resource "aws_launch_template" "mongo_lt" {
  count                  = 3
  name_prefix            = "mongo-lt-${count.index + 1}-"
  image_id               = "resolve:ssm:${var.ssm_parameter_name}"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.mongo_sg.id]
  user_data              = base64encode(templatefile("${path.module}/scripts/init-mongo.sh", { SERVICE_ID = var.cloudmap_service_id }))

  iam_instance_profile {
    name = aws_iam_instance_profile.mongo_profile[count.index].name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "mongo-${count.index + 1}"
    }
  }
}

resource "aws_autoscaling_group" "mongo_asg" {
  count                     = 3
  name                      = "mongo-asg-${count.index + 1}"
  vpc_zone_identifier       = [var.private_subnet_ids[count.index]]
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.mongo_lt[count.index].id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
    }
  }

  tag {
    key                 = "MongoNode"
    value               = count.index + 1
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "mongo-${count.index + 1}"
    propagate_at_launch = true
  }
}