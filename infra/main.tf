provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get existing Internet Gateway
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Subnet (make sure CIDR does NOT conflict with existing subnets)
resource "aws_subnet" "public_1a" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.210.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "motivation-subnet-1a"
  }
}

# Route Table for Internet Access
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "motivation-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

# Security Group allowing SSH and web traffic
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
  ami                    = "ami-0f5ee92e2d63afc18"  # Ubuntu 22.04 LTS in ap-south-1
  instance_type          = "t3.medium"
  key_name               = "lab3"
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
  vpc = true
}

resource "aws_eip_association" "static_ip_assoc" {
  instance_id   = aws_instance.motivation_app.id
  allocation_id = aws_eip.static_ip.id
  depends_on    = [aws_instance.motivation_app]
}
