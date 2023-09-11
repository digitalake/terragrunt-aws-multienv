include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/bastion-security-group.hcl"
}

terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws?version=5.1.0"
}