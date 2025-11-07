########################################
# Terraform Outputs for RefineOps
########################################

output "instance_public_ip" {
  description = "Public IP of the RefineOps k3s EC2 instance"
  value       = aws_instance.k3s_instance.public_ip
}

output "instance_id" {
  description = "Instance ID of the RefineOps EC2"
  value       = aws_instance.k3s_instance.id
}
