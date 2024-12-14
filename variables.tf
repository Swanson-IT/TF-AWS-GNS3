# ---------------------
# VARIABLES
# ---------------------
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
  default     = 512
}

variable "task_memory" {
  description = "Memory (in MiB) for the ECS task"
  type        = number
  default     = 1024
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
  default     = 80
}

variable "task_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}