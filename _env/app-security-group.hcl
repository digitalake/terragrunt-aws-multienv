locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}


dependency "vpc" {
  config_path = "../vpc"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "bastion-security-group" {
  config_path = "../bastion-security-group"
}



inputs = {
  name        = "app-sg-${local.env_name}"
  description = "Security group for the app ASG instances"
  vpc_id      = dependency.vpc.outputs.vpc_id

  tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }
}