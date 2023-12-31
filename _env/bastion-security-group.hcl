locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name        = "bastion-sg-${local.env_name}"
  description = "Security group for the Bastion instance"
  vpc_id      = dependency.vpc.outputs.vpc_id

  tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }
}