module "sg-bastion-server" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "sg_bastion_server" # sg- wont work since it is reserved
  description = "Security group for the"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags


  # Ingress and Egress Rules
   ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow SSH from anywhere"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP from anywhere"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS from anywhere"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

}

module "sg-private-ec2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "sg_private_ec2"
  description = "Security group for the private subnets"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags


 ingress_with_source_security_group_id = [
    {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        source_security_group_id = module.sg-bastion-server.security_group_id
        description = "Allow SSH from bastion host"
        
    },
    {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        source_security_group_id = module.sg-bastion-server.security_group_id
        description = "allow bastion to communicate with jenkins "
        
    },
    {
        from_port = 8081
        to_port = 8081
        protocol = "tcp"
        source_security_group_id = module.sg-bastion-server.security_group_id
        description = "allow bastion to communicate with nexus"
        
    },
    {
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        source_security_group_id = module.sg-bastion-server.security_group_id
        description = "allow bastion to communicate with sonarqube"
        
    }


 ]

egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

}