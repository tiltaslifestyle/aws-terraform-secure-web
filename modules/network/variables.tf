variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "vpc_name" {
  description = "Base name for the VPC and related resources"
  type        = string
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
}
