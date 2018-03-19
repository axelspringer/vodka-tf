# + get data current account
data "aws_caller_identity" "current" {}

# + get data current region
data "aws_region" "current" {}

# + get data terraform locking table
data "aws_dynamodb_table" "tf_lock" {
  name = "tf_locks_${var.project}_${data.aws_caller_identity.current.account_id}"
}

# + get data terraform state bucket
data "aws_s3_bucket" "tf_state" {
  bucket = "tf-${var.project}-${data.aws_caller_identity.current.account_id}"
}
