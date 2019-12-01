terraform {
  backend "s3" {
    bucket = "terraform-state-poc-lukmilczarski"
    key = "terraform.tfstate"
    region = "eu-central-1"
  }
}
