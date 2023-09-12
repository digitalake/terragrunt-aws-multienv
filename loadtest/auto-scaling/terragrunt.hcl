include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/auto-scaling.hcl"
}

terraform {
  source = "tfr:///terraform-aws-modules/autoscaling/aws?version=6.10.0"
}

locals {
  user_data = <<-EOT
  #!/bin/bash
  docker run -d -p 80:3000 ghcr.io/benc-uk/nodejs-demoapp:4.9.7
EOT
}

inputs = {

  min_size         = 1
  max_size         = 4
  desired_capacity = 3

  image_id      = "ami-08b65a28b856b858d"
  instance_type = "t2.micro"
  user_data     = base64encode(local.user_data)
}

