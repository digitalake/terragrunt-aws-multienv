generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket = "grunt-tfstate-multienv"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
  }
}