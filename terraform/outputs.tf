output "instance_public_ip" {
  description = "Public IP of created RefineOps k3s EC2"
  value       = aws_instance.k3s_instance.public_ip
}
