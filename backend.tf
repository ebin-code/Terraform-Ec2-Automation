terraform {
  backend "s3" {
    bucket         = "my-s3-bucket-for-terraform-state-ebink"
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "my-dynamo-db-table-terrafomr-ebi"
  }
}
