include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/bastion.hcl"
}

terraform {
  source = "../../modules/ec2-simple"
}


inputs = {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
}