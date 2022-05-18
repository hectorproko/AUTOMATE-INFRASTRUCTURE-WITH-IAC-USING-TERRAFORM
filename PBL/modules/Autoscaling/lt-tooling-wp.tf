# launch template for wordpress
resource "aws_launch_template" "wordpress-launch-template" {
  image_id               = var.ami-web
  instance_type          = "t2.micro"
  #vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  vpc_security_group_ids = var.web-sg

  iam_instance_profile {
    #name = aws_iam_instance_profile.ip.id
    name = var.instance_profile
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

  tags = merge(
    var.tags,
    {
      Name = format("%s-wordpress-template", var.name) 
    },
  )

}

  #user_data = filebase64("${path.module}/wordpress.sh")
}

# launch template for toooling
resource "aws_launch_template" "tooling-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

  tags = merge(
    var.tags,
    {
      Name = format("%s-tooling-template", var.name) 
    },
  )

  }

  #user_data = filebase64("${path.module}/tooling.sh")
}
