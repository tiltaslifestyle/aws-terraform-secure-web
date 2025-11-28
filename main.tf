# Call the Networking Module
module "network" {
  source = "./modules/network"

  # Passing arguments to the module
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  vpc_name           = var.project_name
  availability_zone  = var.availability_zone
}