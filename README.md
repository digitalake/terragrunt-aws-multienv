# <h1 align="center">Terragrunt task</a>

This repo contains the Terraform + Terragrunt code for deploying multienvironment infrastructure using Terrform wrapper (Terragrunt). The code is placed in several modules for keeping the configurations __DRY__

### The infra scheme

Here is the example of deployed environments (in this case dev+stage) which can have different configs based on requirenments.

> [!IMPORTANT]
> I wasn't able to deploy all the 3 envs because of the resource limitations.

According to the task, the main esources are:
  - the ASG (based on ami created with Packer) with the the dockerized demo-application 
  - the ELB(ALB)
  - the Bastion host (created with personal ec2 module) to access the application servers via ssh-proxy jumps    

![multienv](https://github.com/digitalake/terragrunt-aws-multienv/assets/109740456/247aac15-bb26-4ec0-aadf-d5bddf4ff1d0)


Load Balancers:

<img src="https://github.com/digitalake/terragrunt-aws-multienv/assets/109740456/c13aad3f-3985-4eaa-8f9b-c578c5922954" width="700">



Instances:

<img src="https://github.com/digitalake/terragrunt-aws-multienv/assets/109740456/8c8d4e92-9775-4428-a958-106c9787bb49" width="700">


ASGs:

<img src="https://github.com/digitalake/terragrunt-aws-multienv/assets/109740456/371cd56f-d498-4599-8805-8b52550aa14b" width="450">


### Directory structure

I decided to trust the Terragrunt docs and used some dir structure tips to keep my configuration DRY.

```
.
├── _env
├── dev
│   ├── alb
│   ├── app-security-group
│   ├── auto-scaling
│   ├── bastion
│   ├── bastion-security-group
│   ├── key-pair
│   └── vpc
├── stage
│   ├── alb
│   ├── app-security-group
│   ├── auto-scaling
│   ├── bastion
│   ├── bastion-security-group
│   ├── key-pair
│   └── vpc
├── loadtest
│   ├── alb
│   ├── app-security-group
│   ├── auto-scaling
│   ├── bastion
│   ├── bastion-security-group
│   ├── key-pair
│   └── vpc
└── modules
    └── ec2-simple

```

### Some explanations:

##### DRY provider and backend

The root _terragrunt.hcl_ file is used to generate the provider block

Using "generate" block makes it possible to share the provider block between envs and resource modules.
```
generate "provider" {
  ...
}
```

The root _terragrunt.hcl_ file is also used to define the Backend config.

The _path_relative_to_include()_ functions is very useful when including a backend block inside child .hcl files because it solves the relative paths definition issue.
```
remote_state {
  ...
  config = {
  ...
    key    = "${path_relative_to_include()}/terraform.tfstate"
  ...
  }
}
```

> [!IMPORTANT]
> In my case i used the same S3 just not to create the seperate S3 for each environment.

##### DRY Terragrunt Architecture (_env)

According to the [Terragrunt docs](https://terragrunt.gruntwork.io/docs/features/keep-your-terragrunt-architecture-dry/#using-include-to-dry-common-terragrunt-config), i used an additional folder called ___env_ which contains the common configurations across the three environments (we prefix with _ to indicate that this folder doesn’t contain deployable configurations)

The __env_ content is:
```
_env
├── alb.hcl
├── app-security-group.hcl
├── auto-scaling.hcl
├── bastion.hcl
├── bastion-security-group.hcl
├── key-pair.hcl
└── vpc.hcl
```
Those files are being included into the child _terragrunt.hcl_ files of env  dirs (/dev, /stage, /loadtest).

Lets look inside the vpc.hcl file:

```
locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env
}
```
I used _read_terragrunt_config()_ to load additional context into the the parent configuration by taking advantage of the folder structure, and define the env based logic in the parent configuration.

With this configuration, _env_vars_ is loaded based on which folder is being invoked. For example, when Terragrunt is invoked in the dev/vpc/terragrunt.hcl folder, dev/env.hcl is loaded, while stage/env.hcl is loaded when Terragrunt is invoked in the stage/vpc/terragrunt.hcl folder.
My env.hcl looks simple:

```
locals {
  env = "dev"
}
```

After defining _env_name_, it can be used in the _inputs_:

```
inputs = {
  name = "main-vpc-${local.env_name}"
  ...
  tags = {
    Terraform   = "true"
    Environment = "${local.env_name}"
  }
}
```

I also defined the module dependencies as the common configuration.

##### Environments and deployable modules

/dev, /stage, /loadtest represent ENVs with several resource modules, each containing it's own _terragrunt.hcl_.

I'm including the parent _terragrunt.hcl_ with provider and backend configurations plus the common configuration from __env_ folder:

My child dev/vpc/terragrunt.hcl uses such configuration:

```
include "root" {
  path = find_in_parent_folders() 
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/vpc.hcl"
}
```

Also all the env-specific inputs are defined in child dev/vpc/terragrunt.hcl (in this case CIDRs values) while the common configuration is being included via _include_ block:

```
inputs = {
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
```
##### Dependencies

The module dependencies are being defined via _dependency_ blocks. The outputs are also used as the inputs.

The modules dependencies looks like this:

<img src="https://github.com/digitalake/terragrunt-aws-multienv/assets/109740456/9986ef40-0418-42e4-8808-ea82ee4f4072" width="700">

```
 terragrunt graph-dependencies | dot -Tsvg > graph.svg
```

##### Apply the configuration:

In my configuration, the core difference between envs is the ASG desired capacity, but it's pretty easy to configure the env-specific options in child _terragrunt.hcl_ files.

To apply specific env resorce module:
```
cd <env-name>/<module>/
terragrunt apply
```

To apply the specific env resources:

```
cd <env-name>/
terragrunt run-all apply 
```

To apply all the envs configurations:
```
cd <root-dir>/
terragrunt run-all apply
```

##### After the Apply

To connect to the ec2 of the ASG, the Bastion ec2 host can be used. To perform the ssh-proxy jump:

```
ssh -J <proxy host> <target host>
```

Or its possible to create the ~/.ssh/config, by adding such configuration:

```
Host <proxy host name>
  HostName  <proxy host hostname/ip>
  IdentityFile ~/.ssh/<key name>
  User <username>
  StrictHostKeyChecking no

Host <target host name>
  HostName <target host hostname/ip>
  IdentityFile ~/.ssh/<key name>
  User <username>
  ProxyJump <proxy host name>
  StrictHostKeyChecking no
```

And connect by using:

```
ssh <target host name>
```

An example:

<img src="https://github.com/digitalake/terragrunt-aws-multienv/assets/109740456/6c5fb86f-fd8c-446e-becc-613ca4734ce6" width="250">

The connection result:

<img src="https://github.com/digitalake/terragrunt-aws-multienv/assets/109740456/04e52a8f-8aea-4683-8ebd-9977bdbd9d06" width="500">





