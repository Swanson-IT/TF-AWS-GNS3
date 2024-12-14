variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
}

variable "task_memory" {
  description = "Memory (in MiB) for the ECS task"
  type        = number
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
}

variable "task_count" {
  description = "Number of ECS tasks to run"
  type        = number
}

variable "execution_role_arn" {
  description = "The ARN of the execution role for ECS tasks"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the task role for ECS tasks"
  type        = string
}