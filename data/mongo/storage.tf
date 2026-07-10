data "aws_subnet" "mongo" {
  count = length(var.private_subnet_ids)
  id    = var.private_subnet_ids[count.index]
}

resource "aws_ebs_volume" "mongo_data" {
  count             = 3
  availability_zone = data.aws_subnet.mongo[count.index].availability_zone
  size              = 50
  type              = "gp3"
  encrypted         = true

  tags = {
    Name      = "mongo-data-${count.index + 1}"
    MongoNode = "${count.index + 1}"
  }
}
