variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0e306788ff2473ccb" # Ubuntu 22.04 (N. Virginia)
}

variable "key_name" {
  default = "my-aws-key"
}

variable "instance_name" {
  default = "refineops-k3s-server"
}
