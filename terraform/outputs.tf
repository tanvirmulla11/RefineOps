output "instance_public_ip" {
  description = "Public IP address of the K3s Server"
  value       = aws_instance.k3s_server.public_ip
}
