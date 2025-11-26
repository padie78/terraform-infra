terraform {
  backend "s3" {
    bucket         = "terraform-state-diego78"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
