#ENVIRONMENT CONFIG

variable "environment" {
  description = "value of the environment"
  type        = string
}


#VPC CONFIGURATION

variable "vpc_name" {
  description = "Name of the VPC to be created"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}


# SUBNET CONFIGURATION

variable "availability_zones" {
  description = "List of AWS Availability Zones to use"
  type        = list(string)
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}
variable "public_cidr" {
  description = "CIDR block for public subnets"
  type        = string
}
