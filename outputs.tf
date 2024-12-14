output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.cluster.name
}

output "gns3_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.gns3_service.name
}