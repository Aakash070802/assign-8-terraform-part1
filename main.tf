terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-amd64-server-*"]
  }
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "flask-express-sg"
  description = "Allow Flask, Express, and SSH traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
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
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y

              # Install Python + Flask
              apt install -y python3-pip git
              pip3 install flask

              # Install Node.js
              apt install -y nodejs npm

              # Clone your repo (IMPORTANT: change later)
              cd /home/ubuntu
              git clone https://github.com/Aakash070802/assign-8-terraform-part1.git app

              # Backend setup
              cd app/backend
              pip3 install -r requirements.txt
              nohup python3 app.py &

              # Frontend setup
              cd /home/ubuntu/app/frontend
              npm install
              nohup node app.js &
              EOF

  tags = {
    Name = "Flask-Express-Server"
  }
}