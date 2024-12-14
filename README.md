# GNS3 ECS Fargate Module

This Terraform module provisions a **GNS3 server** container on **AWS ECS Fargate**.

## Prerequisites

- AWS credentials configured
- Terraform >= 1.0.0

## Variables

| Variable                | Default         | Description                          |
|-------------------------|-----------------|--------------------------------------|
| `aws_region`            | `us-east-2`     | AWS region to deploy resources       |
| `vpc_cidr`              | `10.0.0.0/16`   | CIDR block for the VPC               |
| `private_subnet_1_cidr` | `10.0.2.0/24`   | CIDR for the first private subnet    |
| `private_subnet_2_cidr` | `10.0.3.0/24`   | CIDR for the second private subnet   |
| `task_cpu`              | `256`           | CPU units for ECS task               |
| `task_memory`           | `512`           | Memory for ECS task                  |
| `task_count`            | `1`             | Number of tasks to run               |
| `container_port`        | `3080`          | Port exposed by the GNS3 container   |

## Outputs

- `ecs_cluster_name`: Name of the ECS cluster
- `gns3_service_name`: Name of the ECS service

## Usage

```hcl
module "gns3_ecs" {
  source = "./gns3-ecs-module"

  aws_region            = "us-east-2"
  vpc_cidr              = "10.0.0.0/16"
  private_subnet_1_cidr = "10.0.2.0/24"
  private_subnet_2_cidr = "10.0.3.0/24"
  task_cpu              = 256
  task_memory           = 512
  task_count            = 1
  container_port        = 3080
}