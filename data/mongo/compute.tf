data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "mongo_lt" {
  count         = 3
  name_prefix   = "mongo-lt-${count.index + 1}-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.mongo_sg.id]

  iam_instance_profile {
    # Asigna el perfil de IAM exacto para este nodo
    name = aws_iam_instance_profile.mongo_profile[count.index].name
  }

  user_data = filebase64("${path.module}/scripts/init-mongo.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "mongo-${count.index + 1}"
    }
  }
}

resource "aws_autoscaling_group" "mongo_asg" {
  count = 3

  name                      = "mongo-asg-${count.index + 1}"
  vpc_zone_identifier       = [var.private_subnet_ids[count.index]]
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    # Enlaza el ASG con su Launch Template específico
    id      = aws_launch_template.mongo_lt[count.index].id
    version = "$Latest"
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