# Create a VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.vpc_cidr
}

# Create Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "${var.aws_region}b"
}

# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "gns3-ecs-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "gns3_task" {
  family                   = "gns3-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name      = "gns3-container"
      image     = "gns3/gns3-server:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "gns3_service" {
  name            = "gns3-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.gns3_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.gns3_sg.id]
  }

  desired_count = var.task_count
}

# Security Group
resource "aws_security_group" "gns3_sg" {
  vpc_id = aws_vpc.ecs_vpc.id
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
}