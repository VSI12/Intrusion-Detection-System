variable "environment" {
  description = "value of the environment"
  type        = string
}

variable "vpc_cidr_block" {
  description = "value of the VPC CIDR block"
  type = string
}

variable "vpc_name" {
  description = "value of the VPC name"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "public_cidr" {
  description = "CIDR nlock for the public subnet route table"
  type = string
}