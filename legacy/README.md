# `legacy`

A Terraform module which deploys [legacy] to an AWS ECS Cluster created by the `ecs` module.

The module creates the following resource.

* CodePipeline with Roles, and Policies
* Integration in EC2 SSM
* RDS for databases
* Task Definitions for legacy
* S3 Bucket for Assets
* Container Logging
* ECR for Containers
* Integration of ECS Deploy and ECS Service Discovery
* Roles and Policies

## Use

> Terraform modules are updated via `terraform get -update=true` in you project.

You can use the module in your project as follows.

```
module "legacy" {
  source = "github.com/axelspringer/vodka-tf//legacy"

  ... your configs
}
```
