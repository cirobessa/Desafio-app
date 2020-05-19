provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1" # Setting my region to London. Use your own region here
}

resource "aws_ecr_repository" "cirobessa" {
  name = "cirobessa" # Naming my repository
}
