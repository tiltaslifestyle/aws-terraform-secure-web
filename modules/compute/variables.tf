variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "subnet_id" {
  description = "The Subnet ID where the instance will be placed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}