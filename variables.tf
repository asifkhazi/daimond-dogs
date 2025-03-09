variable "aws_region" {
  type        = string
  description = "AWS region for resource"
  default     = "ap-south-1"
}

variable "environment" {
  type        = string
  description = "Environment for daimonddog app"
}

variable "project" {
  type        = string
  description = "value"
}

variable "prefix" {
  type        = string
  description = "value"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}

variable "address_space" {
  type        = string
  description = "VPC cidr address space"
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  type        = string
  description = "value"
  default     = "subnet"
}