module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  depends_on = [ module.vpc ] # creates this vpc before the instance
  version = "5.6.0"
  name                   = "${var.environment}-BastionHost"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair # create the key on aws
  subnet_id              = module.vpc.public_subnets[0] 
  count = 1
  user_data = file("${path.module}/scripts/nginx.sh")
  vpc_security_group_ids = [module.sg-bastion-server.security_group_id]
  tags = local.common_tags
}


module "ec2_private-jenkins" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "terraform-aws-modules/ec2-instance/aws"
 
  version = "5.6.0"
  
  name                   = "${var.environment}-jenkins"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  user_data = file("${path.module}/scripts/jenkins.sh")
  tags = local.common_tags


  vpc_security_group_ids = [module.sg-private-ec2.security_group_id]
  count = 1
  subnet_id =  module.vpc.private_subnets[0] 
  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 30
      tags = {
        Name = "my-root-block"
      }
    },
  ]
}

module "ec2_private-nexus" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "terraform-aws-modules/ec2-instance/aws"
 
  version = "5.6.0"
  
  name                   = "${var.environment}-nexus"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  user_data = file("${path.module}/scripts/nexus.sh")
  tags = local.common_tags


  vpc_security_group_ids = [module.sg-private-ec2.security_group_id]
  count = 1
  subnet_id =  module.vpc.private_subnets[1] 
  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 10
      tags = {
        Name = "my-root-block"
      }
    },
  ]
}

module "ec2_private-sonarqube" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "terraform-aws-modules/ec2-instance/aws"
 
  version = "5.6.0"
  
  name                   = "${var.environment}-sonarqube"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type # use docker
  key_name               = var.instance_keypair
  user_data = file("${path.module}/scripts/docker.sh")
  tags = local.common_tags


  vpc_security_group_ids = [module.sg-private-ec2.security_group_id]
  count = 1
  subnet_id =  module.vpc.private_subnets[0] 
  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 15
      tags = {
        Name = "my-root-block"
      }
    },
  ]
}





