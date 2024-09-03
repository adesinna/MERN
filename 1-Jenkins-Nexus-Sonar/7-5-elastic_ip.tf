resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2_public, module.vpc]
  tags       = local.common_tags
  instance   = module.ec2_public[0].id  # Accessing the first instance ID
  domain     = "vpc"
}
