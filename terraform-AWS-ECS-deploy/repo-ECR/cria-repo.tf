provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1" #  REGIAO DO REPOSITORIO
}

resource "aws_ecr_repository" "cb-counter" {
  name = "cb-counter" #  NOME DO REPOSITORIO ECR
}
