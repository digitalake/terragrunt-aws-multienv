locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "app-security-group" {
  config_path = "../app-security-group"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "key-pair" {
  config_path = "../key-pair"
}

inputs = {
  name                = "application-instance-${local.env_name}"
  health_check_type   = "EC2"
  vpc_zone_identifier = dependency.vpc.outputs.private_subnets
  target_group_arns   = dependency.alb.outputs.target_group_arns
  autoscaling_group_tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }

  launch_template_name        = "application"
  launch_template_description = "Complete launch template with Docker"
  key_name                    = dependency.key-pair.outputs.key_pair_name
  security_groups             = [dependency.app-security-group.outputs.security_group_id]
  tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }
}