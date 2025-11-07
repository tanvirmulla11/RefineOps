#############################################
# Terraform main configuration for RefineOps
# Region: us-east-1 (N. Virginia)
#############################################

# ---- AWS Provider ----
provider "aws" {
  region = "us-east-1"
}

# ---- Get the Latest Ubuntu 22.04 AMI (Auto-detect) ----
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical official Ubuntu account
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# ---- Security Group for k3s EC2 ----
resource "aws_security_group" "k3s_sg" {
  name        = "refineops-k3s-sg"
  description = "Security group for RefineOps k3s cluster"

  ingress = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "App NodePort"
      from_port   = 30080
      to_port     = 30080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# ---- EC2 Instance for k3s Cluster ----
resource "aws_instance" "k3s_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "refineops-k3s-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io git
              sudo systemctl enable --now docker
              curl -sfL https://get.k3s.io | sh -
              sudo docker run -d --name prometheus -p 9090:9090 prom/prometheus
              sudo docker run -d --name grafana -p 3000:3000 grafana/grafana
              EOF
}
