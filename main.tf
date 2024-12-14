# ---------------------
# VPC
# ---------------------
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "gns3-vpc"
  }
}

# ---------------------
# SUBNETS
# ---------------------
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "gns3-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "gns3-private-subnet-2"
  }
}

# ---------------------
# SECURITY GROUP
# ---------------------
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "gns3-sg"

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gns3-sg"
  }
}

# ---------------------
# ECS CLUSTER
# ---------------------
resource "aws_ecs_cluster" "cluster" {
  name = "gns3-cluster"
}

# ---------------------
# ECS TASK DEFINITION
# ---------------------
resource "aws_ecs_task_definition" "task" {
  family                   = "gns3-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name       = "gns3-container"
      image      = "jsimonetti/gns3-server:latest"
      essential  = true
      privileged = true
      environment = [
        {
          name  = "BRIDGE_ADDRESS"
          value = "172.21.1.1/24"
        }
      ]
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "gns3-data"
          containerPath = "/data"
          readOnly      = false
        }
      ]
    }
  ])

  volume {
    name      = "gns3-data"
    host_path = null
  }

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn
}

# ---------------------
# ECS SERVICE
# ---------------------
resource "aws_ecs_service" "service" {
  name            = "gns3-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.sg.id]
  }

  desired_count = var.task_count
}