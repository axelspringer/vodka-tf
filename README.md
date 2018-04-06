# Vodka Terraform Modules

> Vodka is the codename for a delivery architecture. We use the modules in this repository to setup this architecture.

## Getting Started

The modules of this delivery architecture are designed along the [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow). Which means that everything is distinctively setup and named by a **master** and a **develop** branch. While you do not have to use these branches, or can pass in other branches to setup. We highly recommend to use these and follow the workflow.

We use these modules jointly with [tf-preboot](https://github.com/axelspringer/tf-preboot) to run the architecture multi-staged and multi-regioned. Again, we highly recommend to also use this boilerplate to have the best experience.

## Modules

The Vodka architecture is build from many Terraform modules. Every modules contains a good documentation about what it does. All modules are following the Gitflow workflow.

## Playbook

We provide a [playbook](https://github.com/axelspringer/vodka-tf/wiki/Playbook) in our wiki to coach every new DevOps to deploy and maintain the modules of the Vodka architecture.

## License
[MIT](/LICENSE)
