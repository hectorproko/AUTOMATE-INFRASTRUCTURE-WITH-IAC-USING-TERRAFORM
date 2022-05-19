output "ALB-sg" {
#   value = aws_security_group.HRA["${var.name}-ext-ALB"].id
  value = aws_security_group.HRA["HRA-ext-ALB"].id
}


output "IALB-sg" {
  value = aws_security_group.HRA[format("%s-int-ALB", var.name)].id
}


output "bastion-sg" {
  value = aws_security_group.HRA[format("%s-bastion", var.name)].id
}


output "nginx-sg" {
  value = aws_security_group.HRA[format("%s-nginx-reverse-proxy", var.name)].id
}


output "web-sg" {
  value = aws_security_group.HRA[format("%s-webserver", var.name)].id
}


output "datalayer-sg" {
  value = aws_security_group.HRA[format("%s-datalayer", var.name)].id
}
