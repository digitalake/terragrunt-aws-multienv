locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name               = "application-lb-${local.env_name}"
  load_balancer_type = "application"
  vpc_id             = dependency.vpc.outputs.vpc_id
  subnets            = dependency.vpc.outputs.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }
}