# security group for alb, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "ext-alb-sg" {
    name        = format("%s-ext-ALB", var.name)
    vpc_id      = aws_vpc.main.id
    description = "Allow TLS inbound traffic"
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(
        var.tags,
        {
            Name = format("%s-ext-ALB", var.name)
        },
    )
}
# security group for bastion, to allow access into the bastion host from you IP
resource "aws_security_group" "bastion_sg" {
    name        = format("%s-bastion", var.name)
    vpc_id      = aws_vpc.main.id
    description = "Allow incoming HTTP connections."
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(
    var.tags,
        {
            Name = format("%s-bastion", var.name)   
        },
    )
}
#security group for nginx reverse proxy, to allow access only from the extaernal load balancer and bastion instance
resource "aws_security_group" "nginx-sg" {
  name   = format("%s-nginx-reverse-proxy", var.name)
  vpc_id = aws_vpc.main.id
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(
        var.tags,
        {
        Name = format("%s-nginx-reverse-proxy", var.name)
        },
    )
}
resource "aws_security_group_rule" "inbound-nginx-http" {
    type                     = "ingress"
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.ext-alb-sg.id
    security_group_id        = aws_security_group.nginx-sg.id
}
resource "aws_security_group_rule" "inbound-nginx-https" {
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.ext-alb-sg.id
    security_group_id        = aws_security_group.nginx-sg.id
}

