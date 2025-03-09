provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      Owner       = "Globomantics"
      Project     = var.project
      Environment = var.environment
    }
  }
}

resource "aws_vpc" "daimond_dogs" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    name        = "${var.prefix}-vpc-${var.aws_region}"
    environment = var.environment
  }
}

resource "aws_subnet" "daimond_dogs" {
  vpc_id     = aws_vpc.daimond_dogs.id
  cidr_block = var.subnet_prefix
  tags = {
    name = "${var.prefix}-subnet"
  }
}

resource "aws_security_group" "daimond_dogs" {
  vpc_id = aws_vpc.daimond_dogs.id
  name   = "${var.prefix}-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
    Name = "${var.prefix}-security-group"
  }
}

resource "aws_internet_gateway" "daimond_dogs" {
  vpc_id = aws_vpc.daimond_dogs.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table" "daimond_dogs" {
  vpc_id = aws_vpc.daimond_dogs.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.daimond_dogs.id
  }
}

resource "aws_route_table_association" "daimond_dogs" {
  subnet_id      = aws_subnet.daimond_dogs.id
  route_table_id = aws_route_table.daimond_dogs.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "daimond_dogs" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.daimond_dogs.id
  vpc_security_group_ids      = [aws_security_group.daimond_dogs.id]
  user_data_replace_on_change = true
  tags = {
    Name = "${var.prefix}-daimond_dogs-instance"
  }
}