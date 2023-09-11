locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "bastion-security-group" {
  config_path = "../bastion-security-group"
}

dependency "key-pair" {
  config_path = "../key-pair"
}

inputs = {
  name = "bastion-${local.env_name}"

  associate_public_ip_address = true
  subnet_id                   = dependency.vpc.outputs.public_subnets[0]
  vpc_security_group_ids      = [dependency.bastion-security-group.outputs.security_group_id]

  key_name = dependency.key-pair.outputs.key_pair_name

  ebs_optimized     = false
  get_password_data = false

  instance_tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }


}