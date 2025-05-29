provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Use existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Use existing default Internet Gateway attached to the default VPC
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Use existing default route table attached to the default VPC
data "aws_route_table" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  # To get default route table only
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# Create a new subnet in default VPC (change CIDR block to a free range)
resource "aws_subnet" "public_1a" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.10.0/24"  # Change this to any free subnet CIDR block within default VPC range
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "motivation-subnet-1a"
  }
}

# Associate the new subnet with the default route table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = data.aws_route_table.default.id
}

# Security Group in default VPC
resource "aws_security_group" "motivation_sg" {
  name        = "motivation-web-sg-${random_id.suffix.hex}"
  description = "Allow SSH and web traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "motivation-sg-${random_id.suffix.hex}"
  }
}

# EC2 Instance
resource "aws_instance" "motivation_app" {
  ami                    = "ami-0f5ee92e2d63afc18"  # Ubuntu 22.04 LTS
  instance_type          = "t3.medium"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.motivation_sg.id]
  user_data              = file("ec2_setup.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "MotivationWebApp"
  }
}

# Elastic IP for Static IP Binding
resource "aws_eip" "static_ip" {
  instance = aws_instance.motivation_app.id
  domain   = "vpc"
  depends_on = [aws_instance.motivation_app]
}
