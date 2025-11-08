provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_k3s" {
  name        = "allow_k3s_sg"
  description = "Allow Kubernetes and monitoring traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_instance" "k3s_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.allow_k3s.name]

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
