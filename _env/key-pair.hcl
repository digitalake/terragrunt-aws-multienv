locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}


inputs = {

  key_name = "ssh-${local.env_name}"

  tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }
}