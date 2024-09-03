
output "security_group_id_private" {
  description = "The ID of the security group"
  value       = module.sg-private-ec2.security_group_id
}

output "security_group_vpc_id-private" {
  description = "The VPC ID"
  value       = module.sg-private-ec2.security_group_vpc_id
}

output "security_group_id_bastion" {
  description = "The ID of the security group"
  value       = module.sg-bastion-server.security_group_id
}

output "security_group_vpc_id-bastion" {
  description = "The VPC ID"
  value       = module.sg-bastion-server.security_group_vpc_id
}



