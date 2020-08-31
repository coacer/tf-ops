resource "aws_instance" "app" {
  ami                         = "ami-0a78937a56f870721"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = "private-admin"
  subnet_id                   = var.app_subnet_id
  iam_instance_profile        = var.iam_instance_profile
  tags = {
    Name = var.name
    env  = "prd"
  }
}
