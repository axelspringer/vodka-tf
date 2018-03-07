variable "name" {
  description = "Name of the pipeline"
}

variable "org" {
  description = "Name of your organization"
}

variable "repo" {
  description = "Name of your repository"
}

variable "repo_url" {
  description = "Name of your repository url"
}

variable "user_id" {
  description = "User id of the account"
}

variable "oauth_token" {
  description = "OAuth token to access the repository"
}

variable "branches" {
  default = [
    "master",
    "develop",
  ]

  description = "The branches to be build"
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

variable "_prefix_tf_lambda" {
  default = "tf-lambda"
}
