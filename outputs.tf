output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the created public subnet"
  value       = module.network.public_subnet_id
}

output "website_endpoint" {
  description = "Public IP of the web server"
  value       = "http://${module.compute.instance_public_ip}"
}