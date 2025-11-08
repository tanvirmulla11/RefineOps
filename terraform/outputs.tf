output "instance_public_ip" {
  description = "Public IP address of the K3s Server"
  value       = aws_instance.k3s_server.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.k3s_server.id
}

output "instance_public_dns" {
  description = "Public DNS name of the K3s Server"
  value       = aws_instance.k3s_server.public_dns
}
