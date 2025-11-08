############################################################
# AWS Credentials
############################################################
variable "AWS_ACCESS_KEY" {
  description = "AWS Access Key for authentication"
  type        = string
}

variable "AWS_SECRET_KEY" {
  description = "AWS Secret Key for authentication"
  type        = string
}

############################################################
# EC2 Configuration
############################################################
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"  # Free Tier eligible
}

# ✅ Updated to a valid Ubuntu 22.04 LTS AMI (N. Virginia / us-east-1)
variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID (us-east-1)"
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "key_name" {
  description = "Your existing AWS Key Pair name"
  default     = "my-aws-key"
}

variable "instance_name" {
  description = "Tag name for the instance"
  default     = "refineops-k3s-server"
}
