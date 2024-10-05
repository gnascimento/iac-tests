# resource "aws_ecs_cluster" "demo_cluster" {
#   name = "demo-cluster"
# }

# resource "aws_ecs_task_definition" "spring_boot_task" {
#   family                   = "spring-boot-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

#   container_definitions = jsonencode([{
#     name  = "spring-boot-container"
#     image = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/ecs-task-repo/microservicedemo:latest"
#     essential = true
#     portMappings = [{
#       containerPort = 8080
#       hostPort      = 8080
#     }]
#   }])
# }
