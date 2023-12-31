locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}

inputs = {

  name = "main-vpc-${local.env_name}"

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }

}