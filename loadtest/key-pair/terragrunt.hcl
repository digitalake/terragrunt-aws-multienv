include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/key-pair.hcl"
}

terraform {
  source = "tfr:///terraform-aws-modules/key-pair/aws?version=2.0.2"
}

inputs = {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoow053bgoKqii7FgXnRR/cHj/thSk/Nlav9pVX4RKRa+WFuPWl2DegLhEYWw4au0nSKOgsb83+g1lJFkGLMSEYhcMZHWqLK0VSZ5Gzvkj8NiEar6eA/ktQ/FMVYyQOGvKt3NlnJ/WnLhLkaqvBNm/DXc8roBTEXjJYr7JcmHyreOv2LR4J1eUZ7Ka4qX2xSgVW0pcvJxpuStA7IxZo8CF2S5BFFMeNVPvKVrentzDId0Mw5/r+ZpmHYxiIWXwymE9LKTwPaJebtBJg9hgxgZzVUorGihHb7UIR8Eu3/dzTGUmF3+pP6zgwUeZiN9qsCiy+Fs7A3QK1Q+Nypo0icog2FSsbvILi5Z8qibxsfA9nCYlcB0f2zRO5w6euxCDCjE18PZ8v42f5ZArfkgyB+9N23JODrcBrqg5Q+Wnxd3UnCHwFKnmLNwBni0V9hTlxKJhITB/bN+fJ7W6r4puR7JpQZqJDQFoBDOj3BCBn/pV8OdZwJfEhoonc79xbZvvib8= vanadium@wks4"
}
