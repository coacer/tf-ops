output "subnet-1a_id" {
  value = aws_subnet.subnet-1a.id
}

output "subnet-1c_id" {
  value = aws_subnet.subnet-1c.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "elb_sg_id" {
  value = aws_security_group.elb.id
}

output "vpc_id" {
  value = aws_vpc.vpc_main.id
}
