# Call the Networking Module
module "network" {
  source = "./modules/network"

  # Passing arguments to the module
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  vpc_name           = var.project_name
  availability_zone  = var.availability_zone
}

# Call the Compute Module
module "compute" {
  source = "./modules/compute"

  # Passing arguments to the module
  project_name  = var.project_name
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet_id
  instance_type = var.instance_type

  # Read public key material from the specified file
  public_key_material = file(var.public_key_path)
}