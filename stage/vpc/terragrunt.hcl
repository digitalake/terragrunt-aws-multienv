include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/vpc.hcl"
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.1.2"
}
