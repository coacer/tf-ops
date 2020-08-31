resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ucc-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "ucc-igw"
  }
}

resource "aws_route_table" "external" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "ucc-rt"
  }
}

resource "aws_subnet" "subnet-1a" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "ucc-subnet-1a"
  }
}

resource "aws_subnet" "subnet-1c" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "ucc-subnet-1c"
  }
}

resource "aws_route_table_association" "subnet-1a" {
  subnet_id      = aws_subnet.subnet-1a.id
  route_table_id = aws_route_table.external.id
}

resource "aws_route_table_association" "subnet-1c" {
  subnet_id      = aws_subnet.subnet-1c.id
  route_table_id = aws_route_table.external.id
}

resource "aws_eip" "eip_1" {
  instance = var.app_ec2_1_id
  vpc      = true
  tags = {
    Name = "ucc-eip"
  }
}

resource "aws_eip" "eip_2" {
  instance = var.app_ec2_2_id
  vpc      = true
  tags = {
    Name = "ucc-eip"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc_main.id
  service_name = "com.amazonaws.ap-northeast-1.s3"

  tags = {
    Name = "ucc-ep"
  }
}

resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "app"
  vpc_id      = aws_vpc.vpc_main.id
  tags = {
    Name = "ucc-app-sg"
  }
}

resource "aws_security_group_rule" "ingress_http" {
  security_group_id        = aws_security_group.app.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  security_group_id = aws_security_group.app.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["61.26.177.212/32"]
}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "elb" {
  name        = "elb-sg"
  description = "elb"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
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

  tags = {
    Name = "ucc-elb-sg"
  }
}
