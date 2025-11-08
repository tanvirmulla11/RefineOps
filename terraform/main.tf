############################################################
# Provider Configuration
############################################################
provider "aws" {
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

############################################################
# Security Group
############################################################
resource "aws_security_group" "allow_k3s" {
  name        = "allow_k3s_sg"
  description = "Allow SSH, Kubernetes, and monitoring traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow K3s NodePort (Kubernetes)"
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Prometheus"
    from_port   = 9090
    to_port     = 9090
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
    Name = "allow_k3s_sg"
  }
}

############################################################
# EC2 Instance for K3s, Docker, Prometheus, and Grafana
############################################################
resource "aws_instance" "k3s_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_k3s.id]

  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y docker.io curl git
    systemctl enable --now docker
    curl -sfL https://get.k3s.io | sh -
    docker run -d --name prometheus -p 9090:9090 prom/prometheus
    docker run -d --name grafana -p 3000:3000 grafana/grafana
  EOF
}

############################################################
# Output Public IP
############################################################
output "instance_public_ip" {
  value = aws_instance.k3s_server.public_ip
  description = "Public IP address of the K3s Server"
}
