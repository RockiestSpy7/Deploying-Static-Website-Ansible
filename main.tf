locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "Coby"
}

# Stores the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "cobys-terraform-remote-state"
    key     = "terraform.tfstate.dev"
    region  = "us-east-1"
    profile = "Coby"
  }
}

# create vpc module
module "vpc" {
  source = "git@github.com:RockiestSpy7/terraform-modules.git//vpc"
  # environment variables
  region       = local.region
  project_name = local.project_name
  environment  = local.environment

  # vpc variables
  vpc_cider                    = var.vpc_cider
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

# create nat-gateway module
module "nat-gateway" {
  source = "git@github.com:RockiestSpy7/terraform-modules.git//nat-gateway"
  # nat-gateway variables
  project_name               = local.project_name
  environment                = local.environment
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

# request ssl certificate
module "ssl_certificate" {
  source = "git@github.com:RockiestSpy7/terraform-modules.git//acm"
  # acm variables
  domain_name       = var.domain_name
  alternative_names = var.alternative_names
}

# create alb module
module "application_load_balancer" {
  source = "git@github.com:RockiestSpy7/terraform-modules.git//alb"
  # alb variables
  project_name          = local.project_name
  environment           = local.environment
  alb_security_group_id = aws_security_group.alb_security_group.id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  target_type           = var.target_type
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.ssl_certificate.certificate_arn
}

# create record set in route-53 module
module "route_53" {
  source = "git@github.com:RockiestSpy7/terraform-modules.git//route-53"
  # route 53 variables
  domain_name                        = module.ssl_certificate.domain_name
  record_name                        = var.record_name
  application_load_balancer_dns_name = module.application_load_balancer.application_load_balancer_dns_name
  application_load_balancer_zone_id  = module.application_load_balancer.application_load_balancer_zone_id
}