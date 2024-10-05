# resource "aws_ecr_repository" "ecs_task_repo" {
#   name                 = "ecs-task-repo"
#   image_tag_mutability = "MUTABLE"
#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }