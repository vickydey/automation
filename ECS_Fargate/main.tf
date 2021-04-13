
module "levelup-vpc" {
    source      = "./module/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
}

#Define Provider
provider "aws" {
  region = var.AWS_REGION
}

module "ecs-fargate" {
  source  = "cn-terraform/ecs-fargate/aws"
  version = "2.0.25"
  vpc_id = module.levelup-vpc.id
  public_subnets = module.levelup-vpc.public_subnet1_id
  private_subnets = module.levelup-vpc.private_subnet1_id
  # insert the 25 required variables here
}