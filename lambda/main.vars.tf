variable "name" {
  description = "Name of the lambda project"
}

variable "vpc_id" {
  default = ""
}

variable "vpc_subnet_ids" {
  type    = "list"
  default = []
}

variable "vpc_security_group_ids" {
  type    = "list"
  default = []
}

variable "kms_master_key_arn" {
  description = "Arn of the parameter kms keys to be used for encryption"
}

variable "ssm_parameters" {
  type    = "map"
  default = {}
}

variable "github_org" {
  description = "Name of your organization"
}

variable "github_repo" {
  description = "Name of your repository"
}

variable "github_repo_url" {
  description = "Name of your repository url"
}

variable "github_oauth_token" {
  description = "OAuth token to access the repository"
}

variable "github_branches" {
  default = [
    "master",
    "develop",
  ]

  description = "The branches to be build"
}

variable "codebuild_image" {
  default     = "aws/codebuild/golang:1.7.3"
  description = "CodeBuild image to use"
}

variable "codebuild_type" {
  default     = "small"
  description = "CodeBuild instance type"
}

variable "description" {
  default = "A go lambda function. Having fun!"
}

variable "tags" {
  type    = "map"
  default = {}
}

#! private
variable "_on_failure" {
  default = "ROLLBACK"
}
