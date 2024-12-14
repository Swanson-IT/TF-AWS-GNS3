variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet."
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet."
  type        = string
}

variable "task_cpu" {
  description = "CPU units to assign to the ECS task."
  type        = number
}

variable "task_memory" {
  description = "Memory to allocate to the ECS task."
  type        = number
}

variable "task_count" {
  description = "Number of ECS tasks to run."
  type        = number
}

variable "container_port" {
  description = "Port exposed by the GNS3 container."
  type        = number
}