# AWS EC2 Instance Terraform Outputs
# Public EC2 Instances - Bastion Host

## ec2_bastion_public_instance_ids
output "ec2_bastion_public_instance_ids" {
  description = "EC2 instance ID"
  value       = module.ec2_public.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "Public IP address EC2 instance"
  value       = module.ec2_public.public_ip 
}

# Private EC2 Instances - Jenkins
## ec2_private_jenkins_instance_ids
output "ec2_private_jenkins_instance_ids" {
  description = "List of IDs of Jenkins instances"
  value = [
    for ec2private in module.ec2_private-jenkins: 
        ec2private.id
     ]   
}

## ec2_private_jenkins_ip
output "ec2_private_jenkins_ip" {
  description = "List of private IP addresses assigned to the Jenkins instances"
  value = [
    for ec2private in module.ec2_private-jenkins: 
        ec2private.private_ip
     ]  
}

# Private EC2 Instances - Nexus
## ec2_private_nexus_instance_ids
output "ec2_private_nexus_instance_ids" {
  description = "List of IDs of Nexus instances"
  value = [
    for ec2private in module.ec2_private-nexus: 
        ec2private.id
     ]   
}

## ec2_private_nexus_ip
output "ec2_private_nexus_ip" {
  description = "List of private IP addresses assigned to the Nexus instances"
  value = [
    for ec2private in module.ec2_private-nexus: 
        ec2private.private_ip
     ]  
}

# Private EC2 Instances - SonarQube
## ec2_private_sonarqube_instance_ids
output "ec2_private_sonarqube_instance_ids" {
  description = "List of IDs of SonarQube instances"
  value = [
    for ec2private in module.ec2_private-sonarqube: 
        ec2private.id
     ]   
}

## ec2_private_sonarqube_ip
output "ec2_private_sonarqube_ip" {
  description = "List of private IP addresses assigned to the SonarQube instances"
  value = [
    for ec2private in module.ec2_private-sonarqube: 
        ec2private.private_ip
     ]  
}
