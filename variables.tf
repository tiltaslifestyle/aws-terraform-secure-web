variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
}

variable "availability_zone" {
  description = "AWS availability zone for subnet"
  type        = string
}

variable "project_name" {
  description = "Global project name for tagging"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}