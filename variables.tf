# environment variables
variable "region" {}
variable "project_name" {}
variable "environment" {}

# vpc variables
variable "vpc_cider" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}

# security-groups variables
variable "ssh_id" {}

# ssl certificate variables
variable "domain_name" {}
variable "alternative_names" {}

# alb variables
variable "target_type" {}

# route-53 variables
variable "record_name" {}